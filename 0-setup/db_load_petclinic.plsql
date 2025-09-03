CREATE TABLE IF NOT EXISTS types (
  id INT PRIMARY KEY,
  type VARCHAR(30) NOT NULL
);
CREATE INDEX idx_type_name ON types (type);

CREATE TABLE IF NOT EXISTS owners (
  id INT PRIMARY KEY,
  first_name VARCHAR(30),
  last_name VARCHAR(30),
  address VARCHAR(100),
  city VARCHAR(30),
  telephone VARCHAR(20)
);
CREATE INDEX idx_owner_name ON owners (first_name, last_name);

CREATE TABLE IF NOT EXISTS pets (
  id INT PRIMARY KEY,
  name VARCHAR(30),
  birth_date DATE,
  type_id INT NOT NULL,
  owner_id INT NOT NULL,
  FOREIGN KEY (owner_id) REFERENCES owners(id),
  FOREIGN KEY (type_id) REFERENCES types(id)
);
CREATE INDEX idx_pet_name ON pets (name);

INSERT ALL
  INTO types (id, type) VALUES (1, 'dog')
  INTO types (id, type) VALUES (2, 'cat')
  INTO types (id, type) VALUES (3, 'bird')
SELECT * FROM dual;
INSERT ALL
  INTO owners (id, first_name, last_name, address, city, telephone)
  VALUES (1, 'Sally', 'Fields', '3 Sunset Blvd.', 'Los Angeles', '713-555-1212')
  INTO owners (id, first_name, last_name, address, city, telephone)
  VALUES (2, 'Joe', 'Montana', '123 Sandhill Rd.', 'San Francisco', '999-555-1212')
  INTO owners (id, first_name, last_name, address, city, telephone)
  VALUES (3, 'Bob', 'Ross', '123 Happy Valley Dr.', 'San Francisco', '999-555-1212')
SELECT * FROM dual;
INSERT ALL
  INTO pets (id, name, birth_date, type_id, owner_id)
  VALUES (1, 'Uri', DATE '2014-01-01', 1, 1)
  INTO pets (id, name, birth_date, type_id, owner_id)
  VALUES (2, 'Lilah', DATE '2013-01-01', 2, 2)
  INTO pets (id, name, birth_date, type_id, owner_id)
  VALUES (3, 'Elsie', DATE '2020-10-25', 3, 3)
SELECT * FROM dual;

COMMIT;