CREATE TABLE roles (
    role_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE user (
    user_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    firstname VARCHAR(50),
    lastname VARCHAR(50),
    login VARCHAR(50) DEFAULT NULL,
    date_of_birth DATE DEFAULT NULL,
    email VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(50),
    address VARCHAR(250),
    creation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modification_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    role_id INT,
    last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (role_id) REFERENCES roles(role_id) ON DELETE CASCADE
);

CREATE TABLE wine (
    wine_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    img_url VARCHAR(255) ,
    category VARCHAR(50) NOT NULL,
    origin VARCHAR(100),
    price DECIMAL(10,2) NOT NULL,
    description TEXT DEFAULT NULL,
    wine_url VARCHAR(255),
    CONSTRAINT price_positive CHECK (price > 0)
);

CREATE TABLE suggestion (
    suggestion_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id INT DEFAULT NULL, -- Make user_id nullable
    name VARCHAR(200) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    origin VARCHAR(100),
    description TEXT DEFAULT NULL,
    creation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modification_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE CASCADE
);

CREATE TABLE tasting (
    tasting_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(250) NOT NULL,
    date DATE DEFAULT NULL,
    location VARCHAR(255),
    city_name VARCHAR(50) NOT NULL,
    website_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE opinion (
    opinion_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    note DECIMAL(3,1) NOT NULL,
    description VARCHAR(200) NOT NULL,
    wine_id INT NOT NULL,
    user_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (wine_id) REFERENCES wine(wine_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE CASCADE,
    CONSTRAINT note_range CHECK (note >= 0 AND note <= 5)
);

CREATE TABLE questions (
    question_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    question_text TEXT NOT NULL
);

CREATE TABLE answers (
    answer_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    question_id INT NOT NULL,
    answer_text TEXT NOT NULL,
    score_value INT NOT NULL, -- Score de la reponse
    CONSTRAINT fk_question FOREIGN KEY (question_id) REFERENCES questions(question_id)
);

CREATE TABLE user_answers (
    user_answer_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    question_id INT NOT NULL,
    answer_id INT NOT NULL,
    CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES user(user_id),
    CONSTRAINT fk_question_2 FOREIGN KEY (question_id) REFERENCES questions(question_id),
    CONSTRAINT fk_answer FOREIGN KEY (answer_id) REFERENCES answers(answer_id)
);

CREATE TABLE taste_profiles (
    profile_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    min_score INT NOT NULL,
    max_score INT NOT NULL,
    profile_name VARCHAR(255) NOT NULL
);

CREATE TABLE user_scores (
    score_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    total_score INT NOT NULL,
    taste_profile_id INT,  -- Clé étrangère vers la table taste_profiles
    CONSTRAINT fk_user_score FOREIGN KEY (user_id) REFERENCES user(user_id),
    CONSTRAINT fk_taste_profile FOREIGN KEY (taste_profile_id) REFERENCES taste_profiles(profile_id)
);

CREATE TABLE wine_filters (
    filter_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    wine_id INT NOT NULL, 
    color VARCHAR(20),  -- Couleur du vin (Blanc, Rouge, Rosé)
    price_range VARCHAR(50), -- Plage de prix (par exemple : '0-20€', '20-50€', '50-100€', etc.)
    origin VARCHAR(100), -- Origine du vin (par exemple : 'Bordeaux', 'Italie', etc.)
    category VARCHAR(50), -- Catégorie du vin (par exemple : 'Sec', 'Doux', etc.)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (wine_id) REFERENCES wine(wine_id) ON DELETE CASCADE
);

INSERT INTO roles (name) VALUES ('admin'), ('client');

INSERT INTO user (firstname, lastname, date_of_birth, email, password, phone, address, role_id) VALUES
('Jean', 'Dupont', '1985-03-15', 'jean.dupont@email.com', '1234567', '+33612345678', '123 Rue de Paris, Paris', '2'),
('Marie', 'Martin', '1990-07-22', 'marie.martin@email.com', '1234567', '+33623456789', '45 Avenue des Champs-Élysées, Paris', '2'),
('Pierre', 'Bernard', '1988-11-30', 'pierre.bernard@email.com', '1234567', '+33634567890', '78 Rue du Commerce, Lyon', '2'),
('Sophie', 'Petit', '1992-04-18', 'sophie.petit@email.com', '1234567', '+33645678901', '15 Rue de la République, Marseille', '2'),
('Lucas', 'Moreau', '1987-09-25', 'lucas.moreau@email.com', '1234567', '+33656789012', '32 Boulevard Victor Hugo, Nice', '2');

INSERT INTO wine (name, img_url, category, origin, price, description, wine_url) VALUES
("Château d'Esclans Garrus 2021", "assets/uploads/wines/1.png", "Rosé", "Côtes-de-Provence", 115.00, "Un rosé prestigieux offrant une complexité aromatique exceptionnelle, avec des notes de fruits mûrs et une finale longue et élégante", "https://meilleur-vin.fr/fr/vin-rose/81-1770-chateau-d-esclans-garrus-vin-rose.html#/26-volume-075_l/71-millesime-2021"),
("Domaine Vallon des Glauges 2023", "assets/uploads/wines/2.png", "Rosé", "Coteaux-d'Aix-en-Provence", 12.50, "Un rosé équilibré et élégant, présentant des arômes de fruits rouges frais et une belle fraîcheur en bouche", "https://www.twil.fr/france/provence/coteaux-d-aix-en-provence/tradition-wine-79647.html?srsltid=AfmBOorR-p0YwoL7YOR73gPIiwA2Axd6g_jmQh3WQiL2DdehV5wH4LHJ#220488"),
("Château Maïme 2023", "assets/uploads/wines/3.png", "Rosé", "Côtes-de-Provence", 15.00, "Un vin rosé frais et délicat, aux arômes de pêche et de fleurs blanches, idéal pour les repas estivaux", "https://boutique.maison-des-vins.fr/fr/vin-rose-aoc-cotes-provence/1039-chateau-maime-heritage-rose-2023.html"),
("Domaine Ray 2022", "assets/uploads/wines/4.png", "Rosé", "Coteaux-d'Aix-en-Provence", 13.50, "Un rosé accessible et convivial, avec des notes de fraise et une légère acidité rafraîchissante", "https://palaisduvin.be/products/ray-jane-igp-rose-2022-domaine-ray-jane-igp-du-var-syrah-rose-2022"),
("Château Sainte-Roseline 2023", "assets/uploads/wines/5.png", "Rosé", "Côtes-de-Provence", 13.00, "Un rosé biologique de grande qualité, aux arômes complexes de fruits exotiques et une texture soyeuse en bouche", "https://macave.carrefour.fr/produit/chateau-sainte-roseline-cuvee-des-chevaliers-2023-aop-cotes-de-provence-vin-rose"),
("Domaine Jean-Marc Burgaud Morgon Corcelette 2023", "assets/uploads/wines/6.png", "Rouge", "Morgon", 24.90, "Un vin élégant du Beaujolais, offrant des arômes de fruits rouges mûrs et une belle structure tannique", "https://www.caves-carriere.fr/burgaud-jean-marc/30773-beaujolais-villages-lantigne"),
("Domaine d'Aupilhac Languedoc Montpeyroux Les Cocalières 2020",  "assets/uploads/wines/7.png","Rouge", "Languedoc", 22.80, "Un vin du Languedoc aux notes épicées et fruitées, avec une complexité remarquable et une finale persistante", "https://www.millesimes-et-saveurs.com/languedoc-montpeyroux-domaine-d-aupilhac-les-cocalieres-2020-rouge-c2x40034141"),
("Domaine de la Chevalerie Bourgueil Busardières 2019", "assets/uploads/wines/8.png", "Rouge", "Vallée de la Loire", 26.00, "Un Bourgueil structuré et raffiné, présentant des arômes de cassis et de violette, avec une belle longueur en bouche", "https://www.idealwine.com/fr/acheter-vin/2399696-1-bouteille-Bourgueil-Busardieres-Domaine-de-la-Chevalerie-2019-Rouge"),
("Domaine La Calmette Cahors L'Espace Bleu entre les Nuages 2018-19", "assets/uploads/wines/9.png", "Rouge", "Sud-Ouest", 27.80, "Un Cahors moderne et élégant, aux notes de fruits noirs et d'épices, avec des tanins soyeux et une finale harmonieuse", "https://www.cavepurjus.com/fr/sud-ouest-/l-espace-bleu-entre-les-nuages-maya-sallee-et-nicolas-fernandez-1.html"),
("Domaine du Pas de l'Escalette Terrasses du Larzac Le Grand Pas 2020", "assets/uploads/wines/10.png", "Rouge", "Languedoc", 30.00, "Un vin du Languedoc riche et puissant, offrant des arômes de garrigue et de fruits noirs, avec une belle fraîcheur", "https://espace-vin.com/boutique/languedoc-roussillon/terrasses-du-larzac/le-grand-pas/"),
("Domaine de l'Aigle Chardonnay Blanc 2023",  "assets/uploads/wines/11.png","Blanc", "Limoux", 24.90, "Un vin blanc sec aux arômes de fruits blancs et de fleurs blanches, offrant une belle fraîcheur et une finale persistante. Idéal avec des poissons grillés ou des fruits de mer", "https://www.gerard-bertrand.com/products/domaine-de-l-aigle-chardonnay-vin-blanc?srsltid=AfmBOorDsoydn3nG14T0Ww7iNRSp6JcRtwmztBhh-JdKoDKU2Eh-7tzt"),
("Domaine Paul Cherrier Sancerre Blanc 2020", "assets/uploads/wines/12.png", "Blanc", "Sancerre", 21.90, "Un Sancerre élégant avec des notes de fruits blancs, de fleurs et une minéralité marquée. Parfait pour accompagner poissons, fruits de mer ou fromages de chèvre", "https://www.vinsdefrance-roanne.fr/paul-cherrier-4.html"),
("Château Puygueraud Blanc 2015", "assets/uploads/wines/13.png", "Blanc", "Côtes de Bordeaux", 12.00, "Assemblage de Sauvignon Blanc et Sémillon, ce vin offre des arômes de fruits blancs et d'agrumes, avec une belle acidité et une finale persistante. Idéal avec poissons, fruits de mer et viandes blanches", "https://terresmillesimees.com/products/chateau_puygueraud_rouge?srsltid=AfmBOopDnd3H8lZ0uC2BRU39fnQe-ftSnC5HdSDMnQQrmvB_vXaaSyXG"),
("Domaine Maby Lirac La Fermade Blanc 2023", "assets/uploads/wines/14.png", "Blanc", "Lirac", 14.90, "Un vin blanc biologique aux arômes de fruits blancs, de fleurs et de miel, avec une belle fraîcheur et une finale longue. Parfait en apéritif ou avec des fruits de mer", "https://domainemaby.fr/la-fermade-blanc/"),
("Domaine François Pinon Vouvray Sec 2022", "assets/uploads/wines/15.png", "Blanc", "Vouvray", 21.95, "Une belle expression de chenin autour de notes de poire et d'agrumes mûrs mêlés à des touches de miel et de coing. Idéal avec des poissons, fruits de mer ou fromages de chèvre", "https://www.ventealapropriete.com/fr/vins-Loire/Julien-et-Francois-Pinon/JPN0002-Julien-et-Francois-Pinon-Vouvray-Sec-Blanc-2022"),
("Les Bulles de Laura", "assets/uploads/wines/16.png","Pétillant", "Bugey", 8.00, "Vinifiée selon la Méthode Ancestrale, cette cuvée offre une robe dorée avec un nez expressif et croquant aux notes fleuries. Fraîcheur et gourmandise caractérisent ce vin festif, idéal pour les desserts et apéritifs", "https://www.carrefour.fr/p/vin-blanc-les-bulles-de-laura-daniel-boccard-3760182190070"),
("Cerdon Méthode Ancestrale", "assets/uploads/wines/17.png", "Pétillant", "Bugey", 10.00, "Cette cuvée, issue de la Méthode Ancestrale, présente une robe rosée et des arômes de fruits rouges frais. Légère et fruitée, elle apporte une touche de fraîcheur en apéritif ou au dessert", "https://www.carrefour.fr/p/vin-rose-cerdon-bugey-aop-daniel-boccard-3760182190001"),
("La Bulle",  "assets/uploads/wines/18.png","Pétillant", "Provence", 20.70, "Un vin pétillant rosé élaboré en Provence, offrant des arômes délicats de fruits rouges et une effervescence fine. Parfait pour les moments de partage et de convivialité", "https://www.lesgrappes.com/vin/la-coste-la-bulle-rose-11234"),
("Crémant de Bourgogne Blanc", "assets/uploads/wines/19.png", "Pétillant", "Bourgogne", 10.90, "Un Crémant de Bourgogne blanc, sec et élégant, avec des notes de fruits blancs et une belle fraîcheur. Idéal pour l'apéritif ou pour accompagner des fruits de mer", "https://www.hyperboissons.fr/e-boutique/vins-effervescents/sainchargny-n56-blanc-de-blancs-cremant-de-bourgogne/"),
("Crémant d'Alsace Blanc", "assets/uploads/wines/20.png", "Pétillant", "Alsace", 14.00, "Un Crémant d'Alsace blanc, offrant des arômes de fleurs blanches et de fruits à chair blanche, avec une effervescence fine et persistante. Parfait pour les célébrations ou en accompagnement de poissons grillés", "https://www.saint-vallier.com/product/1968008"),
("Pierre Gimonnet Brut Cuis 1er Cru", "assets/uploads/wines/21.png", "Champagne", "Côte des Blancs", 33.95, "Un champagne Blanc de Blancs d'une finesse remarquable, offrant des notes florales et une grande fraîcheur. Idéal à l'apéritif pour réveiller les papilles", "https://www.premiumgrandscrus.com/fr/blanc-de-blancs/674-pierre-gimonnet-fils-cuvee-cuis-champagne-premier-cru.html"),
("Louis Roederer Brut Premier", "assets/uploads/wines/22.png", "Champagne", "Reims", 45.00, "Un champagne élégant et harmonieux, avec des arômes de fruits blancs et une touche de brioche. Parfait pour les grandes occasions", "https://www.ventealapropriete.com/fr/Champagne/Champagne-Roederer/ROE0004-Louis-Roederer-Champagne-Brut-Premier-Blanc"),
("Veuve Clicquot Brut Yellow Label", "assets/uploads/wines/23.png", "Champagne", "Reims", 50.00, "Un champagne emblématique, riche et crémeux, aux notes de fruits mûrs et de vanille. Idéal pour les célébrations", "https://www.carrefour.be/fr/yellow-label-champagne-brut-750-ml/06805406.html"),
("Bollinger Special Cuvée Brut", "assets/uploads/wines/24.png", "Champagne", "Aÿ", 55.00, "Un champagne puissant et raffiné, avec des arômes de fruits secs et une belle longueur en bouche. Parfait pour accompagner des plats gastronomiques", "https://souriredessaveurs.com/1851-bollinger-champagne-special-cuvee-brut-vin-blanc-75-cl-avec-son-etui.html"),
("Ruinart Blanc de Blancs",  "assets/uploads/wines/25.png","Champagne", "Reims", 70.00, "Un champagne 100% Chardonnay, d'une grande pureté, aux notes d'agrumes et de fleurs blanches. Idéal pour les moments d'exception", "https://www.nicolas.com/fr/CHAMPAGNES/Champagnes/CHAMPAGNE-BRUT/MAGNUM-R-DE-RUINART--ETUI-SECONDE-PEAU/p/490262.html"),
("Château de Pibarnon Rouge 2021", "assets/uploads/wines/26.png", "Rouge", "Bandol", 43.00, "Un Bandol d'une grande finesse, aux arômes de fruits noirs, d'épices et de garrigue. Parfait pour accompagner une viande rouge", "https://www.pibarnon.com/vin/vins/vins-emblematiques/le-rouge-2020/"),
("Domaine Tempier Rosé 2023", "assets/uploads/wines/27.png", "Rosé", "Bandol", 38.00, "Un rosé élégant et structuré, offrant des notes de fruits rouges, de pêche et d'épices. Idéal pour les repas estivaux", "https://www.lespassionnesduvin.com/domaine-tempier-bandol-rose-2023-provence.html"),
("Domaine de la Janasse Blanc 2022", "assets/uploads/wines/28.png", "Blanc", "Côtes-du-Rhône", 12.00, "Un vin blanc généreux et aromatique, aux notes de fleurs blanches et de fruits tropicaux. Parfait avec des poissons ou des volailles", "https://millesimes.com/Cotes_du_rhone_blanc_la_janasse_2023_Cotes_du_Rhone_vin_blanc"),
("Pol Roger Réserve Brut", "assets/uploads/wines/29.png", "Champagne", "Épernay", 42.00, "Un champagne classique et raffiné, aux arômes de pomme verte, de brioche et de miel. Idéal pour les grandes occasions", "https://www.aumillesime.com/boutique-en-ligne/vins/champagne/pol-roger-aoc-champagne-brut-reserve-en-etui-blanc"),
("Domaine de la Taille aux Loups Triple Zéro", "assets/uploads/wines/30.png", "Pétillant", "Montlouis-sur-Loire", 21.50, "Un pétillant naturel sans sucre ajouté, offrant une grande fraîcheur et des arômes de fruits blancs. Idéal à l'apéritif", "https://www.lesbellescaves.fr/Les-Petillants/641-Montlouis-Triple-Zero-La-Taille-Aux-Loups.html"),
("Clos de la Roilette Fleurie Cuvée Tardive 2023", "assets/uploads/wines/31.png", "Rouge", "Beaujolais", 25.00, "Un Fleurie complexe et élégant, aux notes de fruits rouges et de fleurs, avec une belle structure tannique", "https://www.lespassionnesduvin.com/fleurie-clos-de-la-roilette-cuvee-tardive-2023-alain-coudert.html"),
("Domaine Ott By.Ott Rosé 2019", "assets/uploads/wines/32.png", "Rosé", "Côtes-de-Provence", 26.00, "Un rosé délicat et fruité, avec des arômes de fraise, de pêche et une touche d'agrumes. Idéal en apéritif ou avec des plats légers", "https://www.carrefour.fr/p/aop-cotes-de-provence-rose-by-ott-2019-3383693000012"),
("Château Smith Haut Lafitte Blanc 2021", "assets/uploads/wines/33.png","Blanc", "Pessac-Léognan", 296.00, "Un grand vin blanc de Bordeaux, aux arômes de fruits exotiques, de fleurs blanches et une belle complexité. Parfait pour un repas gastronomique", "https://bottleofitaly.com/fr/products/chateau-smith-haut-lafitte-blanc-pessac-lognan?variant=47794873532754"),
("Dom Pérignon Vintage 2013", "assets/uploads/wines/34.png", "Champagne", "Épernay", 270.00, "Un champagne d'exception, offrant une richesse aromatique exceptionnelle et une finesse inégalée. Idéal pour les moments d'exception", "https://www.topdrinks.fr/dom-perignon-luminous-blanc-brut-vintage-2013-75cl"),
("Domaine Hubert Lamy Saint-Aubin La Princée 2022", "assets/uploads/wines/35.png", "Blanc", "Bourgogne", 58.00, "Un vin blanc minéral et précis, aux arômes de fruits à chair blanche et une belle fraîcheur. Parfait avec des fruits de mer", "https://www.lesbonsplansduvin.com/vins-de-bourgogne/vins-de-bourgogne-cote-de-beaune/saint-aubin-la-princee-2022-blanc-domaine-hubert-lamy.html"),
("Laurent-Perrier Cuvée Rosé", "assets/uploads/wines/36.png", "Champagne", "Tours-sur-Marne", 92.00, "Un champagne rosé élégant, aux arômes de fruits rouges et une effervescence fine. Parfait pour les célébrations", "https://www.nicolas.com/fr/CHAMPAGNES/Champagne-Laurent-Perrier-Cuvee-Rose/p/070862.html"),
("Domaine du Vissoux Moulin-à-Vent Les Trois Roches 2021",  "assets/uploads/wines/37.png","Rouge", "Beaujolais", 30.00, "Un vin rouge puissant et structuré, aux notes de cerise noire et d'épices. Parfait pour accompagner une viande en sauce", "https://www.pisteurdecrus.fr/beaujolais/233-chermette-moulin-a-vent-la-rochelle.html"),
("Domaine Leflaive Puligny-Montrachet 2020",  "assets/uploads/wines/38.png","Blanc", "Bourgogne", 120.00, "Un grand vin blanc de Bourgogne, offrant une complexité remarquable et des arômes de fruits mûrs et de fleurs blanches", "https://www.xo-vin.fr/sec/20966-003116227-puligny-montrachet-3442321017133.html"),
("Château Simone Rosé 2021",  "assets/uploads/wines/39.png","Rosé", "Palette", 48.00, "Un rosé gastronomique, offrant des arômes complexes de fruits rouges, de fleurs et une touche minérale. Idéal pour accompagner des plats raffinés", "https://www.calais-vins.com/vins-de-provence-alpes-cotes-d-azur/23330-chateau-simone-rose-2022-appellation-palette-provence-75-cl.html"),
("Taittinger Comtes de Champagne Blanc de Blancs 2013", "assets/uploads/wines/40.png", "Champagne", "Reims", 321.00, "Un champagne 100% Chardonnay d'une grande élégance, aux arômes d'agrumes et de fruits secs", "https://www.nicolas.com/fr/CHAMPAGNES/TAITTINGER-COMTES-CHAMPAGNE/p/496773.html"),
("Château d'Yquem 2022", "assets/uploads/wines/41.png", "Blanc", "Sauternes", 168.00, "Un vin liquoreux légendaire, offrant une richesse aromatique exceptionnelle et une douceur parfaite. Idéal pour les desserts", "https://www.12bouteilles.com/fr/chateau-yquem/5083-y-d-yquem-2022.html"),
("Louis Jadot Gevrey-Chambertin 2018", "assets/uploads/wines/42.png", "Rouge", "Bourgogne", 49.00, "Un vin rouge élégant et puissant, aux arômes de fruits noirs, de réglisse et une touche boisée. Parfait pour une viande rouge", "https://maisonsarment.com/products/maison-louis-jadot-gevrey-chambertin"),
("Château Miraval Rosé 2023", "assets/uploads/wines/43.png", "Rosé", "Côtes-de-Provence", 26.00, "Un rosé frais et fruité, aux notes de pêche, de fraise et une belle acidité. Idéal pour l'été", "https://www.vinissimus.fr/fr/vin/miraval-rose/"),
("Henriot Blanc de Blancs", "assets/uploads/wines/44.png",  "Champagne", "Reims", 52.00, "Un champagne 100% Chardonnay, offrant des arômes de fleurs blanches, de fruits secs et une belle finesse", "https://www.nicolas.com/fr/CHAMPAGNES/HENRIOT-BLANC-DE-BLANCS/p/498151.html"),
("Domaine Zind-Humbrecht Riesling Grand Cru Rangen 2020", "assets/uploads/wines/45.png",  "Blanc", "Alsace", 149.00, "Un Riesling grand cru aux arômes de fruits mûrs, de minéralité et une belle acidité. Parfait avec des plats épicés", "https://vinslegarage.be/vfr/riesling-brand-grand-cru-2020-mgn-1-5l-be-bio-02-zind-humbrecht-alsace"),
("Perrier-Jouët Belle Époque 2014", "assets/uploads/wines/46.png", "Champagne", "Épernay", 246.00, "Un champagne d'exception, aux arômes floraux et fruités, avec une effervescence délicate", "https://www.nicolas.com/fr/VINS-FINS/CHAMPAGNES/PERRIER-JOUET-BELLE-EPOQUE-COCOON/p/496297.html"),
("Château Léoville-Las Cases 2018", "assets/uploads/wines/47.png", "Rouge", "Saint-Julien", 276.00, "Un grand vin de Bordeaux, puissant et complexe, aux notes de fruits noirs et d'épices", "https://www.chateauinternet.com/chateau-leoville-las-cases-2018"),
("Château La Nerthe Blanc 2015", "assets/uploads/wines/48.png", "Blanc", "Châteauneuf-du-Pape", 40.00, "Un vin blanc riche et complexe, aux arômes de fruits tropicaux, de fleurs et une touche boisée", "https://www.lenezdansleverre.com/fr/chateau-la-nerthe/271-chateau-la-nerthe-blanc.html"),
("Domaine de la Mordorée Tavel La Dame Rousse 2023", "assets/uploads/wines/49.png", "Rosé", "Tavel", 17.00, "Un rosé structuré et aromatique, aux notes de fruits rouges et une belle fraîcheur", "https://www.domaine-mordoree.com/produit/la-dame-rousse-2023/"),
("Krug Grande Cuvée", "assets/uploads/wines/50.png", "Champagne", "Reims", 310.00, "Un champagne d'exception, riche et complexe, offrant des arômes de fruits mûrs, de noix et une effervescence fine", "https://www.nicolas.com/fr/CHAMPAGNES/Champagne-Krug-Grande-Cuvee-Brut/p/037563.html");


INSERT INTO tasting (name, date, location, city_name, website_url) VALUES
    ("Millésime Bio", "2025-01-27", "Parc des Expositions", "Montpellier", "https://www.millesime-bio.com"),
    ("Salon Vinidôme", "2025-01-31", "Grande Halle d'Auvergne", "Clermont-Ferrand", "https://www.salon-vinifrance.fr/les-salons/clermont-ferrand/"),
    ("Salon des Vins de Loire", "2025-02-03", "Parc des Expositions", "Angers", "https://salondesvinsdeloire.com/"),
    ("Wine Paris / Vinexpo", "2025-02-10", "Paris Porte de Versailles", "Paris", "https://wineparis.com/newfront"),
    ("Salon des Vins de Limoges", "2025-02-14", "Parc des Expositions", "Limoges", "https://www.salon-vinifrance.fr/les-salons/limoges/"),
    ("Salon des Vins Bio de Nantes", "2025-02-28", "Parc des Expositions", "Nantes", "https://www.club-vignerons-laureats.com/salon-des-vins-nantes/#:~:text=Les%2028%20f%C3%A9vrier%2C%201%20%26%202,du%20Ch%C3%A2teau%20de%20la%20Poterie."),
    ("Salon Vins et Terroirs Toulouse", "2025-03-07", "Parc des Expositions MEETT", "Toulouse", "https://www.salon-vins-terroirs-toulouse.com"),
    ("Salon des Vins des Vigerons Indépendants de Lyon", "2025-03-07", "Eurexpo", "Lyon", "https://www.vigneron-independant.com/19%C3%A8me-salon-des-vins-des-vignerons-ind%C3%A9pendants-lyon-eurexpo"),
    ("Salon de la Gastronomie et des Vins", "2025-03-21", "Parc des Expositions", "Caen", "https://www.abcsalles.com/agenda/salon-vins-gastronomie-caen"),
    ("Somm'Up", "2025-03-30", "Palais de la Méditerranée", "Nice", "https://sommup-salon.com/visiteurs/"),
    ("Les Printemps de Châteauneuf-du-Pape", "2025-04-04", "Salle Dufays", "Châteauneuf-du-Pape", "https://www.lesprintempsdechateauneufdupape.fr"),
    ("SAVIM de printemps", "2025-03-21", "Parc Chanot", "Marseille", "https://www.salons-savim.fr"),
    ("Salon des Vins de Macon", "2025-04-25", "Parc des Expositions", "Mâcon", "https://www.salon-des-vins.fr/"),
    ("Salon de la Gastronomie des Vins et des Spiritueux", "2025-05-08", "Place du Bras d'Or", "Pont-l'Évêque", "https://www.calvados-tourisme.com/evenement/41eme-fete-du-fromage-salon-de-la-gastronomie-des-vins-et-spiritueux/"),
    ("Foire aux Vins d'Alsace", "2025-02-25", "Parc Expo de Colmar", "Strasbourg", "https://www.foire-colmar.com/fr/"),
    ("Salon Viti Loire", "2025-05-30", "Tours", "Tours", "https://www.tours.fr/"),
    ("Bacchus", "2025-03-28", "place d'Armes et ville de Toulon", "Toulon", "https://www.bacchus-fete.com/"),
    ("Salon des Vins de Sancerre", "2025-05-01", "Maison des Sancerre", "Sancerre", "https://www.vins-centre-loire.com/fr/foire-aux-vins-de-sancerre"),
    ("Bordeaux fête le vin", "2025-06-19", "Quais de la Garonne", "Bordeaux", "https://www.bordeaux-fete-le-vin.com/billetterie.html?o=Agenda-BFV"),
    ("Salon Vinexpo Bordeaux", "2025-06-16", "Sur les quais de Bordeaux", "Bordeaux", "https://www.vinexpobordeaux.com"),
    ("Salon des Vins du Jura", "2025-03-23", "Grand Gymnase", "Arbois", "https://lenezdanslevert.com/"),
    ("Salon des Vins Artisanaux et Naturels", "2025-03-21", "Hotel Amour Plage", "Nice, France", "https://www.vinsdazur.com/"),
    ("Salon des Vins d'Automne de Colmar", "2025-08-03", "Parc Expo", "Colmar", "https://www.foire-colmar.com/fr/"),
    ("Bacchus", "2025-06-05", "Parc de Valmy", "Argeles-sur-Mer", "https://festival-bacchus.fr/#:~:text=Rendez%2Dvous%20le%205%2C%206%20et%207%20juin%202025%20!"),
    ("Fête des Grands Vins de Bourgogne", "2025-11-14", "Palais des Congrès", "Beaune", "https://www.fetedesgrandsvins.fr/"),
    ("Salon de Paris-Vincennes", "2025-09-05", "Vincennes Hippodrome de Paris", "Paris", "https://www.mer-et-vigne.fr/salons/salon-dautomne-paris-vincennes"),
    ("Vin, Saveurs et Plantes d'Automne", "2025-10-18", "Parc Floral", "Apremont-sur-Allier", "https://www.apremont-sur-allier.com/19-20-octobre-2004-vin-saveurs-et-plantes-dautomne/#:~:text=Agenda-,18%20%26%2019%20Octobre%202025,et%20des%20produits%20du%20terroir."),
    ("Salon du Chocolat & Vins", "2025-10-31", "L'Autre Scène", "Vedène (Avignon)", "https://www.grandavignon-destinations.fr/agenda/salon-du-chocolat-vins/"),
    ("Salon des Vins de Chablis", "2025-10-25", "Chablis", "Chablis", "https://www.chablis.fr/decouvrez/des-traditions-bourguignonnes/la-fete-des-vins/la-fete-des-vins,1242,6986.html"),
    ("Aux Vignobles! Vin est Gastronomie de nos Régions", "2025-01-31", "Halle D'Iraty", "Biarritz", "https://www.auxvignobles.fr/biarritz/"),
    ("Salon des Vins des Vignerons Indépendants de Bordeaux", "2025-03-07", "Parc des Expositions", "Bordeaux", "https://www.jds.fr/bordeaux/foires-et-salons/foires/salon-des-vins-des-vignerons-independants-de-bordeaux-176761_A"),
    ("Salon des Vins Indépendants", "2025-03-21", "Espace Champerret", "Paris", "https://www.vigneron-independant.com/32%C3%A8me-salon-des-vins-des-vignerons-ind%C3%A9pendants-paris-champerret"),
    ("Salon Saveurs et Terroirs", "2025-11-28", "Parc des Expos", "Chambéry", "https://www.saveursetterroirs.com/"),
    ("TERRAVINI", "2025-10-24", "Palais Nikaïa", "Nice", "https://salons-terravini.fr/"),
    ("SAVIM d'Automne", "2025-11-21", "Parc Chanot", "Marseille", "https://www.salons-savim.fr/"),
    ("Salon des Vins des Vignerons Indépendants Paris", "2025-11-28", "Parc des Expositions Porte de Versailles", "Paris", "https://www.vigneron-independant.com"),
    ("Le Grand Tasting", "2025-11-28", "Carrousel du Louvre, Paris, France", "Paris", "https://www.grandtasting.com"),
    ("Salon des Vins et Gourmandises", "2025-02-28", "Complexe sportif Jean Claverie à Laigné en Belin", "Laigne-Saint-Gervais", "https://clubdesloisirslaigne.fr/"),
    ("Salon d'Annecy", "2025-10-17", "Route de Thône", "Annecy", "https://www.mer-et-vigne.fr/salons/salon-annecy-le-vieux-espace-rencontre");

    
INSERT INTO opinion (note, description, wine_id, user_id) VALUES
(4.5, "Vin excellent avec une belle complexité. Très équilibré, j'ai adoré!", 1, 1),
(3.8, "Un bon vin, mais je trouve que le goût manque un peu de profondeur.", 2, 2),
(5.0, "Absolument incroyable! La qualité de ce vin est exceptionnelle.", 3, 3),
(2.5, "Le vin n'est pas à la hauteur de mes attentes. Un peu trop amer.", 4, 4),
(4.0, "Très bon vin, agréable et bien structuré. À recommander.", 5, 5),
(3.2, "Un bon vin mais pas assez de caractère pour moi. Un peu trop léger.", 6, 1),
(4.7, "Arômes de fruits confits et une belle longueur en bouche, un de mes préférés!", 7, 2),
(4.3, "Très bon rapport qualité/prix, avec des notes fruitées et épicées.", 8, 3),
(4.9, "Vin robuste, mais très élégant. Un must pour les amateurs!", 9, 4),
(3.0, "Un peu trop acide pour mon goût, mais reste correct.", 10, 5),
(4.4, "Une belle bouteille, agréable à boire et facile à apprécier.", 11, 1),
(3.5, "Un vin un peu trop sucré à mon goût, mais il est assez rafraîchissant.", 12, 2),
(4.6, "Très agréable avec des poissons. Les arômes sont parfaits.", 13, 3),
(5.0, "Un classique! Dom Pérignon ne déçoit jamais. Parfait pour des occasions spéciales.", 14, 4),
(4.0, "Parfait pour l'été, léger et frais, très bon vin rosé.", 15, 5),
(3.7, "Pas mal du tout, mais un peu trop sec à mon goût.", 16, 1),
(4.2, "Un vin agréable avec des arômes d’épices, parfait pour les viandes grillées.", 17, 2),
(4.8, "Un vin d'exception pour accompagner les desserts. Très doux et équilibré.", 18, 3),
(3.9, "Bon vin mais peut-être un peu trop intense pour un dîner léger.", 19, 4),
(5.0, "Un vin riche et complexe. Parfait pour les grandes occasions.", 20, 5);

INSERT INTO questions (question_text) VALUES
("Quel niveau d'acidité aimez-vous dans un vin ?"),
("Préférez-vous un vin léger ou puissant ?"),
("Quel arôme recherchez-vous dans un vin ?"),
("Préférez-vous un vin sec ou sucré ?"),
("Quel type de vin préférez vous?");

-- Question 1 : Quel niveau d'acidité aimez-vous dans un vin ?
INSERT INTO answers (question_id, answer_text, score_value) VALUES
(1, 'Faible acidité', 1),
(1, 'Acidité modérée', 2),
(1, 'Acidité élevée', 3);

-- Question 2 : Préférez-vous un vin léger ou puissant ?
INSERT INTO answers (question_id, answer_text, score_value) VALUES
(2, 'Léger', 1),
(2, 'Modéré', 2),
(2, 'Puissant', 3);

-- Question 3 : Quel arôme recherchez-vous dans un vin ?
INSERT INTO answers (question_id, answer_text, score_value) VALUES
(3, 'Fruité', 1),
(3, 'Épicé', 2),
(3, 'Boisé', 3),
(3, 'Floral', 4);

-- Question 4 : Préférez-vous un vin sec ou sucré ?
INSERT INTO answers (question_id, answer_text, score_value) VALUES
(4, 'Sec', 1),
(4, 'Demi-sec', 2),
(4, 'Sucré', 3);

-- Question 5 : Quel type de vin préférez-vous ?
INSERT INTO answers (question_id, answer_text, score_value) VALUES
(5, 'Rouge', 1),
(5, 'Blanc', 2),
(5, 'Rosé', 3);

-- Réponses des utilisateurs

INSERT INTO user_answers (user_id, question_id, answer_id) VALUES
(1, 1, 2),  -- Jean Dupont répond à la première question (acidité modérée)
(1, 2, 3),  -- Jean Dupont répond à la deuxième question (puissant)
(1, 3, 1),  -- Jean Dupont répond à la troisième question (fruity)
(1, 4, 1),  -- Jean Dupont répond à la quatrième question (sec)
(1, 5, 1),  -- Jean Dupont répond à la cinquième question (rouge)

-- Marie Martin avec user_id = 2
(2, 1, 3),  -- Marie Martin répond à la première question (acidité élevée)
(2, 2, 1),  -- Marie Martin répond à la deuxième question (léger)
(2, 3, 2),  -- Marie Martin répond à la troisième question (épicé)
(2, 4, 2),  -- Marie Martin répond à la quatrième question (demi-sec)
(2, 5, 2);  -- Marie Martin répond à la cinquième question (blanc)

-- Insérer les profils de goût en fonction des scores
INSERT INTO taste_profiles (min_score, max_score, profile_name) VALUES
(0, 5, 'Adepte des vins légers'),  -- Scores entre 0 et 5 : Profil "Adepte des vins légers"
(6, 10, 'Explorateur de vins'),    -- Scores entre 6 et 10 : Profil "Explorateur de vins"
(11, 15, 'Épicurien'),             -- Scores entre 11 et 15 : Profil "Épicurien"
(16, 20, 'Connaisseur des grands crus'); -- Scores entre 16 et 20 : Profil "Connaisseur des grands crus"

-- Insérer les scores des utilisateurs
-- Ce score correspond au profil "Épicurien" (score entre 11 et 15)

INSERT INTO user_scores (user_id, total_score, taste_profile_id) VALUES
(1, 12, 3);  -- Profil "Épicurien" a `profile_id = 3`

-- -- Ajouter des filtres pour les vins
INSERT INTO wine_filters (wine_id, color, price_range, origin, category) VALUES
(1, 'Rouge', '0-50€', 'Bordeaux', 'Sec'), -- Château Margaux : Rouge, moins de 50€, Bordeaux, sec
(2, 'Rouge', '200-500€', 'Bourgogne', 'Fruité'), -- Domaine de la Romanée-Conti : Rouge, entre 200€ et 500€, Bourgogne, fruité
(3, 'Rouge', '400-800€', 'Pomerol', 'Riche'), -- Pétrus : Rouge, entre 400€ et 800€, Pomerol, riche
(4, 'Rouge', '50-100€', 'Italie', 'Tannique'), -- Sassicaia : Rouge, entre 50€ et 100€, Italie, tannique
(10, 'Blanc', '20-50€', 'Allemagne', 'Acide'), -- Riesling Trocken : Blanc, entre 20€ et 50€, Allemagne, acide
(11, 'Rouge', '0-30€', 'Argentine', 'Fruité'), -- Malbec Argentin : Rouge, moins de 30€, Argentine, fruité
(12, 'Blanc', '20-50€', 'Loire', 'Sec'); -- Pouilly-Fumé : Blanc, entre 20€ et 50€, Loire, sec

