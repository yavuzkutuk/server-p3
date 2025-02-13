import databaseClient from "../../../database/client";

import type { Result, Rows } from "../../../database/client";

interface Tasting {
  tasting_id: number;
  name: string;
  date: string;
  city_id: number;
  website_url: string;
}
class TastingRepository {
  // The C of CRUD - Create operation

  async create(tasting: Omit<Tasting, "tasting_id">) {
    const [result] = await databaseClient.query<Result>(
      "insert into tasting (name, date, city_id, website_url) values (?, ?, ?, ?)",
      [tasting.name, tasting.date, tasting.city_id, tasting.website_url],
    );

    // Return the ID of the newly inserted tasting
    return result.insertId;
  }

  // The Rs of CRUD - Read operations

  async read(id: number) {
    // Execute the SQL SELECT query to retrieve a specific tasting by its ID
    const [rows] = await databaseClient.query<Rows>(
      "select * from tasting where tasting_id = ?",
      [id],
    );

    // Return the first row of the result, which represents the tasting
    return rows[0] as Tasting;
  }

  async readAll() {
    // Execute the SQL SELECT query to retrieve all tastings from the "tasting" table
    const [rows] = await databaseClient.query<Rows>("select * from tasting");

    // Return the array of tastings
    return rows as Tasting[];
  }

  // The U of CRUD - Update operation
  async update(tasting: Tasting) {
    // Execute the SQL UPDATE query to update an existing tasting in the "tasting" table
    const [result] = await databaseClient.query<Result>(
      "update tasting set name = ?, date = ?, city_id = ?, website_url = ? where tasting_id = ?",
      [
        tasting.name,
        tasting.date,
        tasting.city_id,
        tasting.website_url,
        tasting.tasting_id,
      ],
    );

    // Return how many rows were affected
    return result.affectedRows;
  }

  // The D of CRUD - Delete operation
  async delete(id: number) {
    // Execute the SQL DELETE query to delete an existing tasting from the "tasting" table
    const [result] = await databaseClient.query<Result>(
      "delete from tasting where tasting_id = ?",
      [id],
    );

    // Return how many rows were affected
    return result.affectedRows;
  }
}

export default new TastingRepository();
