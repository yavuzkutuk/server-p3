import databaseClient from "../../../database/client";

import type { Result, Rows } from "../../../database/client";

interface Wine {
  wine_id: number;
  name: string;
  img_url: string;
  category: string;
  origin: string | null;
  price: number;
  description: string | null;
}
class wineRepository {
  // The C of CRUD - Create operation

  async create(wine: Omit<Wine, "wine_id">) {
    const [result] = await databaseClient.query<Result>(
      "insert into wine (name, img_url, category, origin, price, description) values (?, ?, ?, ?, ?, ?)",
      [
        wine.name,
        wine.img_url,
        wine.category,
        wine.origin,
        wine.price,
        wine.description,
      ],
    );

    // Return the ID of the newly inserted wine
    return result.insertId;
  }

  // The Rs of CRUD - Read operations

  async read(id: number) {
    // Execute the SQL SELECT query to retrieve a specific wine by its ID
    const [rows] = await databaseClient.query<Rows>(
      "select * from wine where wine_id = ?",
      [id],
    );

    // Return the first row of the result, which represents the wine
    return rows[0] as Wine;
  }

  async readAll() {
    // Execute the SQL SELECT query to retrieve all wines from the "wine" table
    const [rows] = await databaseClient.query<Rows>("select * from wine");

    // Return the array of wines
    return rows as Wine[];
  }

  async update(wine: Wine) {
    // Execute the SQL UPDATE query to update an existing wine in the "wine" table
    const [result] = await databaseClient.query<Result>(
      "update wine set name = ? where wine_id = ?",
      [wine.name, wine.wine_id],
    );

    // Return how many rows were affected
    return result.affectedRows;
  }

  async delete(id: number) {
    // Execute the SQL DELETE query to delete an existing wine from the "category" table
    const [result] = await databaseClient.query<Result>(
      "delete from wine where wine_id = ?",
      [id],
    );

    // Return how many rows were affected
    return result.affectedRows;
  }
}

export default new wineRepository();
