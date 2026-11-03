DROP TABLE IF EXISTS PARTICIPER;
DROP TABLE IF EXISTS JOUEUR;
DROP TABLE IF EXISTS RENCONTRE;
DROP TABLE IF EXISTS POSTE;
DROP TABLE IF EXISTS EQUIPE;

CREATE TABLE EQUIPE(
    id_equipe INT AUTO_INCREMENT,
    nom_equipe VARCHAR(50) NOT NULL,
    ville VARCHAR(50) NOT NULL,
    stade VARCHAR(50) NOT NULL,
    PRIMARY KEY(id_equipe),
    UNIQUE(nom_equipe)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE POSTE(
    id_poste INT AUTO_INCREMENT,
    libelle_poste VARCHAR(30) NOT NULL,
    min_vitesse INT DEFAULT 0,
    min_endurance INT DEFAULT 0,
    min_force INT DEFAULT 0,
    min_technique INT DEFAULT 0,
    PRIMARY KEY(id_poste),
    UNIQUE(libelle_poste),
    CHECK (
        min_vitesse BETWEEN 0 AND 100 AND
        min_endurance BETWEEN 0 AND 100 AND
        min_force BETWEEN 0 AND 100 AND
        min_technique BETWEEN 0 AND 100
    )
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE JOUEUR(
    id_joueur INT AUTO_INCREMENT,
    nom VARCHAR(30) NOT NULL,
    prenom VARCHAR(30) NOT NULL,
    numero_maillot INT NOT NULL,
    vitesse INT NOT NULL,
    endurance INT NOT NULL,
    force_physique INT NOT NULL,
    technique INT NOT NULL,
    matchs_suspension_blessure INT NOT NULL DEFAULT 0,
    id_poste INT NOT NULL,
    id_equipe INT NOT NULL,
    PRIMARY KEY(id_joueur),
    FOREIGN KEY(id_poste) REFERENCES POSTE(id_poste),
    FOREIGN KEY(id_equipe) REFERENCES EQUIPE(id_equipe),
    CHECK (
        vitesse BETWEEN 0 AND 100 AND
        endurance BETWEEN 0 AND 100 AND
        force_physique BETWEEN 0 AND 100 AND
        technique BETWEEN 0 AND 100 AND
        matchs_suspension_blessure >= 0
    )
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE RENCONTRE(
    id_rencontre INT AUTO_INCREMENT,
    date_rencontre DATETIME NOT NULL,
    score_domicile INT DEFAULT NULL,
    score_exterieur INT DEFAULT NULL,
    statut VARCHAR(20) NOT NULL DEFAULT,
    id_equipe_domicile INT NOT NULL,
    id_equipe_visiteur INT NOT NULL,
    PRIMARY KEY(id_rencontre),
    FOREIGN KEY(id_equipe_domicile) REFERENCES EQUIPE(id_equipe),
    FOREIGN KEY(id_equipe_visiteur) REFERENCES EQUIPE(id_equipe),
    CHECK (id_equipe_domicile <> id_equipe_visiteur),
    CHECK (
        (score_domicile IS NULL OR score_domicile >= 0) AND
        (score_exterieur IS NULL OR score_exterieur >= 0)
    )
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE PARTICIPER(
    id_joueur INT NOT NULL,
    id_rencontre INT NOT NULL,
    note_performance INT DEFAULT NULL,
    est_blesse BOOLEAN DEFAULT FALSE,
    diff_vitesse INT DEFAULT 0,
    diff_endurance INT DEFAULT 0,
    diff_force INT DEFAULT 0,
    diff_technique INT DEFAULT 0,
    PRIMARY KEY(id_joueur, id_rencontre),
    FOREIGN KEY(id_joueur) REFERENCES JOUEUR(id_joueur) ON DELETE CASCADE,
    FOREIGN KEY(id_rencontre) REFERENCES RENCONTRE(id_rencontre) ON DELETE CASCADE,
    CHECK (note_performance IS NULL OR note_performance BETWEEN 0 AND 10)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;