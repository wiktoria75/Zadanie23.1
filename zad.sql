CREATE DATABASE my_employees CHARACTER SET utf8 COLLATE utf8_polish_ci;
-- 1) Tworzy tabelę pracownik(imie, nazwisko, wyplata, data urodzenia, stanowisko). W tabeli mogą być
-- dodatkowe kolumny, które uznasz za niezbędne.
CREATE TABLE employees (
                           id INT PRIMARY KEY AUTO_INCREMENT,
                           `name` VARCHAR(12) NOT NULL,
                           surname VARCHAR(16) NOT NULL,
                           salary DOUBLE,
                           birthday DATE,
                           title VARCHAR(25)
);

-- 2) Wstawia do tabeli co najmniej 6 pracowników
INSERT INTO employees
(name, surname, salary, birthday, title)
VALUES
    ('Marcin','Marciniuk','23000','1985-04-30','CEO'),
    ('Adam','Adamczyk','6000','1991-05-31','Engineer'),
    ('Adam','Adamczyk','6000','1991-05-31','Engineer'),
    ('Tomasz','Tomaszewski','2400','1989-12-05','Assistant'),
    ('Piotr','Piotrowski','4000','1985-01-15','Menager'),
    ('Michał','Michalski','18000','1972-11-18','CFO');

-- 3) Pobiera wszystkich pracowników i wyświetla ich w kolejności alfabetycznej po nazwisku
SELECT * FROM employees ORDER BY surname ASC, name ASC;

-- 4) Pobiera pracowników na wybranym stanowisku
SELECT * FROM employees WHERE title = 'CEO';

-- 5) Pobiera pracowników, którzy mają co najmniej 30 lat
SELECT * FROM employees WHERE birthday <= (NOW() - INTERVAL 30 YEAR);

-- 6) Zwiększa wypłatę pracowników na wybranym stanowisku o 10%
UPDATE employees SET salary = (salary * 1.1) WHERE title = 'Assistant';

-- 7) Pobiera najmłodszego pracowników (uwzględnij przypadek, że może być kilku urodzonych tego samego dnia)
SELECT * FROM employees WHERE birthday = (SELECT max(birthday) FROM employees);

-- 8) Usuwa tabelę pracownik
DROP TABLE employees;

-- 9) Tworzy tabelę stanowisko (nazwa stanowiska, opis, wypłata na danym stanowisku)
CREATE TABLE stanowisko (
                            pos_no int PRIMARY KEY NOT NULL AUTO_INCREMENT,
                            position VARCHAR(20),
                            `description` VARCHAR(250),
                            `salary` DOUBLE
);

-- 10) Tworzy tabelę adres (ulica+numer domu/mieszkania, kod pocztowy, miejscowość)
CREATE TABLE adres (
                       adr_no int PRIMARY KEY NOT NULL AUTO_INCREMENT,
                       street VARCHAR(30),
                       zip_code INT(5) ZEROFILL,
                       city VARCHAR(15)
);

-- 11) Tworzy tabelę pracownik (imię, nazwisko) + relacje do tabeli stanowisko i adres
CREATE TABLE pracownik (
                           emp_no INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
                           `name` VARCHAR(15),
                           surname VARCHAR(15)
);

ALTER TABLE pracownik
    ADD position_id INT,
        ADD FOREIGN KEY (position_id) REFERENCES stanowisko (pos_no);

ALTER TABLE adres
    ADD emp_id INT,
        ADD FOREIGN KEY (emp_id) REFERENCES pracownik (emp_no);

-- 12)Dodaje dane testowe (w taki sposób, aby powstały pomiędzy nimi sensowne powiązania)
INSERT INTO stanowisko
(position, description, salary)
VALUES
    ('CEO','', '40000'),
    ('Engineer','', '13000'),
    ('Menager', '', '15000');

INSERT INTO pracownik
(name, surname, position_id)
VALUES
    ('Marcin','Marciniuk','1'),
    ('Adam','Adamczyk','2'),
    ('Tomasz','Tomaszewski','2'),
    ('Piotr','Piotrowski','2'),
    ('Michał','Michalski','3');

INSERT INTO adres
(emp_id, street, zip_code, city)
VALUES
    ('1', 'Grochowska 4/3', '02104', 'Warszawa'),
    ('2', 'Czerniakowska 45/18', '03485', 'Warszawa'),
    ('3', 'Grójecka 23/8', '01249', 'Warszawa'),
    ('4', 'Niepodległości 3/5', '02365', 'Warszawa'),
    ('5', 'Książęca 8/31', '03822', 'Warszawa');

-- 13) Pobiera pełne informacje o pracowniku (imię, nazwisko, adres, stanowisko)
SELECT
    name, surname, position, salary, street, zip_code
FROM pracownik p
         JOIN stanowisko ON p.position_id = stanowisko.pos_no
         JOIN adres ON p.emp_no = adres.emp_id;


-- 14) Oblicza sumę wypłat dla wszystkich pracowników w firmie
SELECT
    sum(salary)
FROM
    pracownik JOIN stanowisko ON pracownik.position_id = stanowisko.pos_no;

-- 15) Pobiera pracowników mieszkających w lokalizacji z kodem pocztowym 90210 (albo innym, który będzie miał sens dla Twoich danych testowych)
SELECT
    name, surname, street, zip_code
FROM pracownik p
         JOIN adres ON p.emp_no = adres.emp_id
WHERE zip_code = '01249';