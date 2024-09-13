USE pharmacogenomics_db;

CREATE TABLE Drug (
   ID INT PRIMARY KEY AUTO_INCREMENT,
   DrugName VARCHAR(50)  
);

CREATE TABLE Gene ( 
ID INT PRIMARY KEY AUTO_INCREMENT, 
GeneName VARCHAR(50) 
);

CREATE TABLE Genotype (
   ID INT PRIMARY KEY AUTO_INCREMENT,
   GeneID INT UNIQUE, 
   Allele1 VARCHAR(50),
   Allele2 VARCHAR(50),
   FOREIGN KEY (GeneID) REFERENCES Gene(ID)
);

CREATE TABLE Phenotype (
   ID INT PRIMARY KEY AUTO_INCREMENT,
   GeneID INT UNIQUE,  
   Phenotype VARCHAR(255), 
   FOREIGN KEY (GeneID) REFERENCES Gene(ID)
);

CREATE TABLE Dosing_Recommendations (
   ID INT PRIMARY KEY AUTO_INCREMENT,
   DrugID INT,
   GenotypeID INT NULL,
   GeneID  INT,
   PhenotypeID INT NULL,
   Recommendation VARCHAR(255),
   Source VARCHAR(50),
   FOREIGN KEY (DrugID) REFERENCES Drug(ID),
   FOREIGN KEY (GeneID) REFERENCES Gene(ID),
   FOREIGN KEY (GenotypeID) REFERENCES Genotype(ID),
   FOREIGN KEY (PhenotypeID) REFERENCES Phenotype(ID)
);


INSERT INTO Drug (DrugName) VALUES ('abrocitinib');
INSERT INTO Drug (DrugName) VALUES ('amitriptyline');
INSERT INTO Drug (DrugName) VALUES ('belzutifan');
INSERT INTO Drug (DrugName) VALUES ('brivaracetam');
INSERT INTO Drug (DrugName) VALUES ('carisoprodol');
INSERT INTO Drug (DrugName) VALUES ('citalopram');
INSERT INTO Drug (DrugName) VALUES ('clobazam');
INSERT INTO Drug (DrugName) VALUES ('clomipramine');
INSERT INTO Drug (DrugName) VALUES ('clopidogrel');
INSERT INTO Drug (DrugName) VALUES ('dexlansoprazole');
INSERT INTO Drug (DrugName) VALUES ('diazepam');
INSERT INTO Drug (DrugName) VALUES ('doxepin');


Select * FROM Drug;

INSERT INTO Gene (GeneName) VALUES ('CYP2C19');
INSERT INTO Gene (GeneName) VALUES ('CYP2D6');

Select * FROM Gene;

DELETE FROM Gene WHERE ID = 3;

-- For CYP2C19 *2/*2
INSERT INTO Genotype (GeneID, Allele1, Allele2) VALUES (2, '*2', '*2');

-- For CYP2D6 undefined (assuming null means not specified)
INSERT INTO Genotype (GeneID, Allele1, Allele2) VALUES (1, 'undefined', 'undefined');

Select * FROM Genotype;

-- Example of possible phenotype entries (these would have to be defined further based on actual clinical data)
INSERT INTO Phenotype (GeneID, Phenotype) VALUES (1, 'Poor Metabolizer');

-- Abrocitinib and CYP2C19 *2/*2 (FDA recommendation)
INSERT INTO Dosing_Recommendations (DrugID, GeneID, GenotypeID, Recommendation, Source) 
VALUES ((SELECT ID FROM Drug WHERE DrugName='abrocitinib'), 
        (SELECT ID FROM Gene WHERE GeneName='CYP2C19'),
        (SELECT ID FROM Genotype WHERE GeneID=(SELECT ID FROM Gene WHERE GeneName='CYP2C19') AND Allele1='*2' AND Allele2='*2'),
        'FDA recommends dose adjustment based on metabolism changes.', 
        'FDA');

-- Amitriptyline and CYP2C19 *2/*2, CYP2D6 undefined (CPIC recommendation)
INSERT INTO Dosing_Recommendations (DrugID, GeneID, GenotypeID, Recommendation, Source) 
VALUES ((SELECT ID FROM Drug WHERE DrugName='amitriptyline'), 
        (SELECT ID FROM Gene WHERE GeneName='CYP2C19'),
        (SELECT ID FROM Genotype WHERE GeneID=(SELECT ID FROM Gene WHERE GeneName='CYP2C19') AND Allele1='*2' AND Allele2='*2'),
        'CPIC recommends alternate drug due to poor metabolism.', 
        'CPIC');

-- Clopidogrel and CYP2C19 *2/*2 (CPIC recommendation)
INSERT INTO Dosing_Recommendations (DrugID, GeneID, GenotypeID, Recommendation, Source) 
VALUES ((SELECT ID FROM Drug WHERE DrugName='clopidogrel'), 
        (SELECT ID FROM Gene WHERE GeneName='CYP2C19'),
        (SELECT ID FROM Genotype WHERE GeneID=(SELECT ID FROM Gene WHERE GeneName='CYP2C19') AND Allele1='*2' AND Allele2='*2'),
        'CPIC recommends alternate drug for neurovascular and cardiovascular indications.', 
        'CPIC');
        
SELECT * FROM Dosing_Recommendations;

SELECT
    d.DrugName,
    g.GeneName,
    gr.Allele1,
    gr.Allele2,
    dr.Recommendation,
    dr.Source
FROM
    Drug d
JOIN
    Dosing_Recommendations dr ON d.ID = dr.DrugID
JOIN
    Genotype gr ON dr.GenotypeID = gr.ID
JOIN
    Gene g ON dr.GeneID = g.ID
WHERE
    gr.Allele1 = '*2' AND gr.Allele2 = '*2';





