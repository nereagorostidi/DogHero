const functions = require("firebase-functions"); // Firebase Functions
const admin = require("firebase-admin");         // Firebase Admin SDK
const nodemailer = require("nodemailer");        // Paquete para enviar correos

admin.initializeApp();                           // Inicializa Firebase Admin

// Configuración del transportador de correo (SMTP)
const transporter = nodemailer.createTransport({
  service: "gmail", // Puedes usar otro servicio como Outlook
  auth: {
    user: "dog.heroadoption@gmail.com",         // Tu dirección de correo
    pass: "oqibxkdpleiqnjmk",                   // Contraseña de aplicación
  },
});

// Parámetros globales para controlar el envío de notificaciones y correos
const FCMSend = false; // Cambiar a `false` si no quieres enviar notificaciones push
const MailSend = true; // Cambiar a `false` si no quieres enviar correos

exports.markAsAdoptedOrRejected = functions.https.onRequest(async (req, res) => {
  try {
    // Obtén los parámetros de la URL
    const dogId = req.query.dogId;
    const email = req.query.email; // Email del usuario (opcional)
    const fcmToken = req.query.fcmToken;
    const rejectAdoption = req.query.rejectAdoption === "true"; // Detecta si se solicita rechazar la adopción

    // Validaciones
    if (!dogId || !fcmToken) {
      return res.status(400).send('Faltan parámetros: "dogId" o "fcmToken".');
    }

    // Referencia al documento en la colección 'dogs'
    const dogRef = admin.firestore().collection('dogs').doc(dogId);

    // Verifica si el documento existe
    const doc = await dogRef.get();
    if (!doc.exists) {
      return res.status(404).send(`El perro con ID ${dogId} no existe.`);
    }

    // Verifica el estado actual del perro
    const dogData = doc.data();
    if (dogData.status !== "reservated") {
      return res
        .status(400)
        .send(`El perro con ID ${dogId} no está en estado "reservated".`);
    }

    // Si se solicita rechazar la adopción
    if (rejectAdoption) {
      await dogRef.update({ status: "ready-to-adopt" });

      // Enviar notificación push si FCMSend es true
      if (FCMSend) {
        const rejectMessage = {
          notification: {
            title: "Adopción rechazada",
            body: "La adopción de su perro ha sido rechazada.",
          },
          token: fcmToken,
        };
        await admin.messaging().send(rejectMessage);
      }

      // Enviar correo si MailSend es true
      if (MailSend && email && email.trim() !== "") {
        const mailOptions = {
          from: "dog.heroadoption@gmail.com",
          to: email,
          subject: "Adopción rechazada",
          text: `
            Estimado usuario,

            Lamentamos informarle que la adopción de su perro ha sido rechazada. El perro vuelve a estar disponible para adopción.

            Gracias por su comprensión.
          `,
        };
        await transporter.sendMail(mailOptions);
        console.log(`Correo enviado a ${email}`);
      }

      return res.status(200).send(
        `La adopción del perro con ID ${dogId} ha sido rechazada. Notificación y correo enviados (si correspondía). El perro vuelve a estar disponible para adopción.`
      );
    }

    // Si no se rechaza, procede con la adopción
    await dogRef.update({ status: "adopted" });

    // Enviar notificación push si FCMSend es true
    if (FCMSend) {
      const adoptMessage = {
        notification: {
          title: "Adopción autorizada",
          body: "Se ha autorizado la adopción de su perro.",
        },
        token: fcmToken,
      };
      await admin.messaging().send(adoptMessage);
    }

    // Enviar correo si MailSend es true
    if (MailSend && email && email.trim() !== "") {
      const mailOptions = {
        from: "dog.heroadoption@gmail.com",
        to: email,
        subject: "Adopción autorizada",
        text: `
          ¡Felicidades!

          La adopción de su perro ha sido autorizada. En breve nos pondremos en contacto con usted para iniciar los trámites correspondientes.

          Muchas gracias por su interés en la adopción responsable.
        `,
      };
      await transporter.sendMail(mailOptions);
      console.log(`Correo enviado a ${email}`);
    }

    return res.status(200).send(
      `El estado del perro con ID ${dogId} ha sido actualizado a "adopted". Notificación y correo enviados (si correspondía).`
    );
  } catch (error) {
    console.error("Error en la función:", error);
    return res.status(500).send("Error interno del servidor.");
  }
});
