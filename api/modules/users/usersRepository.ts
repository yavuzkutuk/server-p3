import databaseClient from "../../../database/client";

import type { ResultSetHeader, RowDataPacket } from "mysql2/promise";

type Result = ResultSetHeader;
type Rows = RowDataPacket[];

type User = {
  token: string;
  user_id: number;
  firstname: string;
  lastname: string;
  login: string;
  date_of_birth: string | null;
  email: string;
  password: string;
  phone: string | null;
  address: string | null;
  creation_date: string;
  modification_date: string;
  role_id: number;
  last_update: string;
};

class UsersRepository {
  // The C of CRUD - Create operation

  async create(user: Omit<User, "user_id" | "last_update">) {
    const [result] = await databaseClient.query<Result>(
      "INSERT INTO user (firstname, lastname, login, date_of_birth, email, password, phone, address, creation_date, modification_date, role_id) VALUES ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
      [
        user.firstname,
        user.lastname,
        user.login,
        user.date_of_birth,
        user.email,
        user.password,
        user.phone,
        user.address,
        user.creation_date,
        user.modification_date,
        user.role_id,
      ],
    );

    return result.insertId;
  }

  async read(id: number) {
    const [rows] = await databaseClient.query<Rows>(
      "SELECT * FROM user WHERE user_id = ?",
      [id],
    );

    return rows[0] as User;
  }

  // The Rs of CRUD - Read operations

  async checkuser(login: string, password: string) {
    const [rows] = await databaseClient.query<Rows>(
      "SELECT * FROM user WHERE login = ? AND password = ?",
      [login, password],
    );

    return rows[0] as User;
  }

  async readAll() {
    const [rows] = await databaseClient.query<Rows>("SELECT * FROM user");
    return rows as User[];
  }

  // The U of CRUD - Update operation
  async update(user: User) {
    // Vérifier et convertir role_id avant l'UPDATE
    user.role_id = user.role_id
      ? Number.parseInt(user.role_id.toString(), 10)
      : 0;

    const [result] = await databaseClient.query<Result>(
      "UPDATE user SET firstname = ?, lastname = ?, login = ?, date_of_birth = ?, email = ?, password = ?, phone = ?, address = ?, creation_date = ?, modification_date = CURDATE(), role_id = ? WHERE user_id = ?",
      [
        user.firstname,
        user.lastname,
        user.login,
        user.date_of_birth,
        user.email,
        user.password,
        user.phone,
        user.address,
        user.creation_date,
        user.role_id, // Maintenant bien converti en INT ou NULL
        user.user_id,
      ],
    );

    return result.affectedRows;
  }

  // The D of CRUD - Delete operation
  async delete(id: number) {
    const [result] = await databaseClient.query<Result>(
      "DELETE FROM user WHERE user_id = ?",
      [id],
    );

    return result.affectedRows;
  }
}

export default new UsersRepository();
