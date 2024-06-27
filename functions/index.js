/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const functions = require("firebase-functions/v2");
const logger = require("firebase-functions/logger");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// Sample function example
// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

/* Install midtrans-client (https://github.com/Midtrans/midtrans-nodejs-client) NPM package.
   npm install --save midtrans-client */

const midtransClient = require("midtrans-client");

// Create Snap API instance
const snap = new midtransClient.Snap({
  // Set to true if you want Production Environment (accept real transaction).
  isProduction: false,
  serverKey: "SB-Mid-server-qzhJH-QZp_c49H12g0hMpS0I",
  clientKey: "SB-Mid-client-U9WbOyKZqSH2Zqjr",
});

// Export midtransPaymentRequest function
exports.midtransPaymentRequest = functions.https.onRequest(async (req, res) => {
  const orderId = req.body.orderId;
  const amount = +req.body.amount;
  const name = req.body.name;
  const phone = req.body.phone;
  const email = req.body.email;
  const parameter = {
    transaction_details: {
      order_id: orderId,
      gross_amount: amount,
    },
    credit_card: {
      secure: true,
    },
    customer_details: {
      first_name: name,
      last_name: "",
      email: email,
      phone: phone || "",
    },
  };

  try {
    const transaction = await snap.createTransaction(parameter);
    const transactionToken = transaction.token;
    logger.info("Transaction Token:", {transactionToken});
    res.status(200).send({
      transactionToken: transactionToken,
      redirectUrl: transaction.redirect_url,
    });
  } catch (error) {
    logger.error("Error creating transaction:", {error});
    res.status(500).send({error: "Error creating transaction"});
  }
});
