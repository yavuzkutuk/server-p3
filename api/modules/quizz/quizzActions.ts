import type { RequestHandler } from "express";

// Import access to data
import questionRepository from "./quizzRepository";

// The B of BREAD - Browse (Read All) operation
const browse: RequestHandler = async (req, res, next) => {
  try {
    // Fetch all items
    const questions = await questionRepository.readAll();

    // Respond with the items in JSON format
    res.json(questions);
  } catch (err) {
    // Pass any errors to the error-handling middleware
    next(err);
  }
};

// The R of BREAD - Read operation
const read: RequestHandler = async (req, res, next) => {
  try {
    // Fetch a specific item based on the provided ID
    const questionsId = Number(req.params.id);
    const questions = await questionRepository.read(questionsId);

    // If the item is not found, respond with HTTP 404 (Not Found)
    // Otherwise, respond with the item in JSON format
    if (questions == null) {
      res.sendStatus(404);
    } else {
      res.json(questions);
    }
  } catch (err) {
    // Pass any errors to the error-handling middleware
    next(err);
  }
};

// The A of BREAD - Add (Create) operation
const add: RequestHandler = async (req, res, next) => {
  try {
    // Extract the item data from the request body
    const newQuestion = {
      question_id: req.body.question_id,
      question_text: req.body.question_text,
    };

    // Create the item
    const insertId = await questionRepository.create(newQuestion);

    // Respond with HTTP 201 (Created) and the ID of the newly inserted item
    res.status(201).json({ insertId });
  } catch (err) {
    // Pass any errors to the error-handling middleware
    next(err);
  }
};

export default { browse, read, add };
