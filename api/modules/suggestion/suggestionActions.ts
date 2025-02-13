import type { RequestHandler } from "express";
import suggestionRepository from "./suggestionRepository";

interface SuggestionVin {
  suggestion_id: number;
  name: string;
  price: number;
  origin: string;
  description: string;
}

// The B of BREAD - Browse (Read All) operation
const browse: RequestHandler = async (req, res, next) => {
  try {
    const suggestion = await suggestionRepository.readAll();
    res.json(suggestion);
  } catch (err) {
    next(err);
  }
};

// The R of BREAD - Read operation
const read: RequestHandler = async (req, res, next) => {
  try {
    const suggestionId = Number(req.params.id);
    const suggestion = await suggestionRepository.read(suggestionId);

    if (!suggestion) {
      res.status(404).send("Not Found");
    } else {
      res.json(suggestion);
    }
  } catch (err) {
    next(err);
  }
};

// The A of BREAD - Add (Create) operation
const add: RequestHandler = async (req, res, next) => {
  try {
    const newSuggestion = {
      name: req.body.name,
      price: req.body.price,
      origin: req.body.origin,
      description: req.body.description,
      creation_date: new Date().toISOString().slice(0, 19).replace("T", " "), // Format: YYYY-MM-DD HH:MM:SS
      modification_date: new Date().toISOString(),
      user_id: req.body.user_id, // Added user_id property
    };

    const insertId = await suggestionRepository.create(newSuggestion);
    res.status(201).json({ insertId });
  } catch (err) {
    next(err);
  }
};

// The E of BREAD - Edit operation
const edit: RequestHandler = async (req, res, next) => {
  try {
    const suggestion = {
      suggestion_id: Number(req.params.id),
      name: req.body.name,
      price: req.body.price,
      origin: req.body.origin,
      description: req.body.description,
      creation_date: req.body.creation_date,
      modification_date: new Date().toISOString(),
      user_id: req.body.user_id,
    };

    const affectedRows = await suggestionRepository.update(suggestion);
    if (affectedRows === null) {
      res.sendStatus(404);
    } else {
      res.sendStatus(204);
    }
  } catch (err) {
    next(err);
  }
};

// The D of BREAD - Destroy operation
const destroy: RequestHandler = async (req, res, next) => {
  try {
    const suggestionId = Number(req.params.id);
    await suggestionRepository.delete(suggestionId);
    res.sendStatus(204);
  } catch (err) {
    next(err);
  }
};

export default { browse, read, add, edit, destroy };
