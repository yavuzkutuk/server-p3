import express from "express";
import cors from "cors";
const app = express();
// Load environment variables from .env file
import "dotenv/config";

if (process.env.CLIENT_URL != null) {
	app.use(cors({ origin: [process.env.CLIENT_URL] }));
} else {
	app.use(cors());
}

// Check database connection
// Note: This is optional and can be removed if the database connection
// is not required when starting the application
/* import "../database/checkConnection"; */

// Import the Express application from ./app

app.use(express.json());
app.use(express.urlencoded());
app.use(express.text());
app.use(express.raw());

/* ************************************************************************* */

// Import the API router
import router from "./router";

// Mount the API router under the "/api" endpoint
app.use(router);

// Get the port from the environment variables
const port = process.env.APP_PORT;

// Start the server and listen on the specified port
app.listen(port, () => {
	console.info(`Server is listening on port ${port}`);
});

module.exports = app;
