const { onRequest } = require("firebase-functions/v2/https");
const axios = require('axios');
const { log } = require("firebase-functions/logger");

const settings = {
    region: "europe-west1",
    memory: "256MiB",
    timeoutSeconds: 15,
    cors: true
}

exports.sendEmailWithBrevoApi = onRequest(settings, async (req, res) => {
    // Ensure the original request is a POST request
    if (req.method !== 'POST') {
        res.status(400).send('Bad Request: Only POST requests are allowed.');
        return;
    }

    // Ensure the original request body contains data
    if (!req.body) {
        res.status(400).send('Bad Request: Request body is missing.');
        return;
    }

    const requestBody = req.body;
    const newUrl = 'https://api.brevo.com/v3/smtp/email';

    ////////////////////////////////////
    /// DO NOT CHECK IN THIS API KEY ///
    ////////////////////////////////////
    const apiKey = '';

    try {
        // Set the headers for the new request
        const headers = {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'api-key': apiKey,
        };

        // Make a POST request to the target URL with the original request body and headers
        const response = await axios.post(newUrl, requestBody, {
            headers: headers,
        });

        // Return the response data to the caller
        res.status(response.status).json(response.data);
    } catch (error) {
        // Handle any errors that occur during the request
        const errorMessage = error.response ? error.response.data : error.message;
        res.status(error.response ? error.response.status : 500).send(errorMessage);
    }
});