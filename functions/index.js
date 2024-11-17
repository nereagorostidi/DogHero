/**
 * Este código implementa una función que se ejecuta en Firebase como una Cloud Function.
 * No se ejecuta en el dispositivo móvil, sino que actúa directamente sobre la base de datos Firestore
 * utilizada por la aplicación móvil y puede enviar notificaciones push (FCM) y correos electrónicos.
 * La función se activa a través de una URL y recibe parámetros para procesar las solicitudes
 * (como autorizar o rechazar la adopción de un perro).
 */

const functions = require("firebase-functions"); // Firebase Functions
const admin = require("firebase-admin");         // Firebase Admin SDK
const nodemailer = require("nodemailer");        // Paquete para enviar correos

admin.initializeApp();                           // Inicializa Firebase Admin

// Configuración del transportador de correo (SMTP)
const transporter = nodemailer.createTransport({
  service: "gmail", // Puedes usar otro servicio como Outlook
  auth: {
    user: "dog.heroadoption@gmail.com",         // Dirección de correo
    pass: "oqibxkdpleiqnjmk",                   // Contraseña de aplicación
  },
});

// Parámetros globales para controlar el envío de notificaciones y correos
let FCMSend = true; // Si es true, se enviarán notificaciones push
let MailSend = true; // Si es true, se enviarán correos electrónicos

// Función principal que gestiona la adopción o rechazo
exports.markAsAdoptedOrRejected = functions.https.onRequest(async (req, res) => {
  try {
    // Obtén los parámetros de la URL
    const dogId = req.query.dogId; // ID del perro en Firestore
    const email = req.query.email?.trim() || ""; // Email del usuario (opcional)
    const fcmToken = req.query.fcmToken; // Token FCM del dispositivo para enviar notificaciones
    const rejectAdoption = req.query.rejectAdoption === "true"; // Detecta si se solicita rechazar la adopción

    // Si el email es "No proporcionado" o "No valido", desactiva el envío de correos
    if (email === "No proporcionado" || email === "No valido") {
      MailSend = false;
    }

    // Validaciones para asegurarse de que los parámetros esenciales están presentes
    if (!dogId || !fcmToken) {
      return res.status(400).send('Faltan parámetros: "dogId" o "fcmToken".');
    }

    // Referencia al documento en la colección 'dogs'
    const dogRef = admin.firestore().collection('dogs').doc(dogId);

    // Verifica si el documento del perro existe
    const doc = await dogRef.get();
    if (!doc.exists) {
      return res.status(404).send(`El perro con ID ${dogId} no existe.`);
    }

    // Verifica el estado actual del perro (debe estar en estado "reservated")
    const dogData = doc.data();
    if (dogData.status !== "reservated") {
      return res
        .status(400)
        .send(`El perro con ID ${dogId} no está en estado "reservated".`);
    }

    // Si se solicita rechazar la adopción
    if (rejectAdoption) {
      // Actualiza el estado del perro a "ready-to-adopt"
      await dogRef.update({ status: "ready-to-adopt" });

      // Enviar notificación push si está habilitado
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

      // Enviar correo si está habilitado
      if (MailSend) {
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

      // Responde indicando que la adopción fue rechazada
      return res.status(200).send(
        `La adopción del perro con ID ${dogId} ha sido rechazada. Notificación y correo enviados (si correspondía).`
      );
    }

    // Si no se rechaza, procede con la adopción
    // Actualiza el estado del perro a "adopted"
    await dogRef.update({ status: "adopted" });

    // Enviar notificación push si está habilitado
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

    // Enviar correo si está habilitado
    if (MailSend) {
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

    // Responde indicando que la adopción fue autorizada
    return res.status(200).send(
      `El estado del perro con ID ${dogId} ha sido actualizado a "adopted". Notificación y correo enviados (si correspondía).`
    );
  } catch (error) {
    // Maneja errores y responde con un mensaje genérico
    console.error("Error en la función:", error);
    return res.status(500).send("Error interno del servidor.");
  }
});
