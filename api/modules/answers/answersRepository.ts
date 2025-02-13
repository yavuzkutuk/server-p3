import databaseClient from "../../../database/client";

import type { Result, Rows } from "../../../database/client";

interface Answer {
  answer_id: number;
  question_id: string;
  answer_text: string;
  score_value: number;
}
class answersRepository {
  // The C of CRUD - Create operation

  async create(answers: Omit<Answer, "answers_id">) {
    const [result] = await databaseClient.query<Result>(
      "insert into answers (answer_id, question_id, answer_text, score_value) values (?, ?, ?, ?)",
      [
        answers.answer_id,
        answers.question_id,
        answers.answer_text,
        answers.score_value,
      ],
    );

    // Return the ID of the newly inserted answers
    return result.insertId;
  }

  // The Rs of CRUD - Read operations

  async read(id: number) {
    // Execute the SQL SELECT query to retrieve a specific answers by its ID
    const [rows] = await databaseClient.query<Rows>(
      "select * from answers where answers_id = ?",
      [id],
    );

    // Return the first row of the result, which represents the answers
    return rows[0] as Answer;
  }

  async readAll() {
    // Execute the SQL SELECT query to retrieve all items from the "item" table
    const [rows] = await databaseClient.query<Rows>("select * from answers");

    // Return the array of items
    return rows as Answer[];
  }

  // The U of CRUD - Update operation
  // TODO: Implement the update operation to modify an existing item

  // async update(item: Item) {
  //   ...
  // }

  // The D of CRUD - Delete operation
  // TODO: Implement the delete operation to remove an item by its ID

  // async delete(id: number) {
  //   ...
  // }
}

export default new answersRepository();
