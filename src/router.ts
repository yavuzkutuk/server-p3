import express from "express";

const router = express.Router();

/* ************************************************************************* */
// Define Your API Routes Here
/* ************************************************************************* */

/* import answerActions from "./modules/answers/answersActions";
// Define item-related routes
import tastingActions from "./modules/degustation/tastingActions";
import itemActions from "./modules/item/itemActions";
import quizzActions from "./modules/quizz/quizzActions";
import suggestionActions from "./modules/suggestion/suggestionActions";
import userActions from "./modules/users/usersActions";
import wineActions from "./modules/vin/wineActions"; */

router.get("/api", (req, res) => res.send("test"));
/* router.get("/api/items", itemActions.browse);
router.get("/api/items/:id", itemActions.read);
router.post("/api/items", itemActions.add);

router.get("/api/wines", wineActions.browse);
router.get("/api/wines/:id", wineActions.read);
router.post("/api/wines", wineActions.add);
router.put("/api/wines/:id", wineActions.edit);
router.delete("/api/wines/:id", wineActions.destroy);

router.get("/api/tastings", tastingActions.browse);
router.get("/api/tastings/:id", tastingActions.read);
router.post("/api/tastings", tastingActions.add);

router.get("/api/users", userActions.browse);
router.get("/api/users/:id", userActions.read);
router.post("/api/users", userActions.add);
router.put("/api/users/:id", userActions.edit);
router.delete("/api/users/:id", userActions.destroy);

import SignIn from "./modules/auth/auth";
router.post("/api/auth/signin", SignIn.SignIn);
router.post("/api/auth/signup", SignIn.SignUp);
router.get("/api/auth/check", SignIn.Check);

router.get("/api/question", quizzActions.browse);
router.get("/api/question/:id", quizzActions.read);
router.post("/api/question", quizzActions.add);

router.get("/api/answers", answerActions.browse);
router.get("/api/answers/:id", answerActions.read);
router.post("/api/answers", answerActions.add);

router.get("/api/suggestion", suggestionActions.browse);
router.get("/api/suggestion/:id", suggestionActions.read);
router.post("/api/suggestion", suggestionActions.add);
router.put("/api/suggestion/:id", suggestionActions.edit);
router.delete("/api/suggestion/:id", suggestionActions.destroy); */

/* ************************************************************************* */

export default router;
