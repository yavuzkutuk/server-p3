import type { RequestHandler } from "express";
import userRepository from "./usersRepository";

interface User {
  user_id: number;
  firstname: string;
  lastname: string;
  login: string;
  password: string;
  email: string;
  date_of_birth: Date;
  phone: string;
  address: string;
  creation_date: string;
  modification_date: string;
  role_id: number;
  last_update: string;
  token: string;
}

// The B of BREAD - Browse (Read All) operation
const browse: RequestHandler = async (req, res, next) => {
  try {
    const users = await userRepository.readAll();
    res.json(users);
  } catch (err) {
    next(err);
  }
};

// The R of BREAD - Read operation
const read: RequestHandler = async (req, res, next) => {
  try {
    const userId = Number(req.params.id);
    const user = await userRepository.read(userId);

    if (!user) {
      res.sendStatus(404);
    } else {
      res.json(user);
    }
  } catch (err) {
    next(err);
  }
};

// The A of BREAD - Add (Create) operation
const add: RequestHandler = async (req, res, next) => {
  try {
    const newUser = {
      firstname: req.body.firstname,
      lastname: req.body.lastname,
      login: req.body.login,
      password: req.body.password,
      email: req.body.email,
      date_of_birth: req.body.date_of_birth,
      phone: req.body.phone,
      address: req.body.address,
      creation_date: new Date().toISOString().slice(0, 19).replace("T", " "), // Format: YYYY-MM-DD HH:MM:SS
      modification_date: new Date()
        .toISOString()
        .slice(0, 19)
        .replace("T", " "),
      role_id: req.body.role_id,
      token: req.body.token,
    };

    const insertId = await userRepository.create(newUser);
    res.status(201).json({ insertId });
  } catch (err) {
    next(err);
  }
};

// The E of BREAD - Edit operation
const edit: RequestHandler = async (req, res, next) => {
  try {
    const user = {
      user_id: Number(req.params.id),
      firstname: req.body.firstname,
      lastname: req.body.lastname,
      login: req.body.login,
      password: req.body.password,
      email: req.body.email,
      date_of_birth: req.body.date_of_birth,
      phone: req.body.phone,
      address: req.body.address,
      creation_date: req.body.creation_date,
      modification_date: new Date().toISOString(),
      role_id: req.body.role_id,
      token: req.body.token,
      last_update: new Date().toISOString(),
    };

    const affectedRows = await userRepository.update(user);
    if (affectedRows === 0) {
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
    const userId = Number(req.params.id);
    await userRepository.delete(userId);
    res.sendStatus(204);
  } catch (err) {
    next(err);
  }
};

export default { browse, read, add, edit, destroy };
