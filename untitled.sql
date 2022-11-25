-- Задание для подготовки к контрольной:
-- Вы являетесь ведущим архитектором IT компании, которой поручили создать реляционную модель данных сети аэропортов.
-- Входные данные (что мы имеем в результате первого раунда общения с аналитиками):
-- Модель содержит следующие сущности:
-- - Аэропорты
-- - Самолеты
-- - Пассажиры
-- - Рейсы (информация о полете)
-- - Экипаж (пилоты, стюардессы, техники и др.)
--
-- 1) Построить физическую модель данных, которая максимально описывает начальные условия системы.
-- 2) Заполнить получившиеся таблицы тестовыми данными (как минимум 3 аэропорта, 3 самолета и 10 рейсов).
-- 3) Вывести самый продолжительный по времени рейс.
-- 4) Вывести количество рейсов для каждого аэропорта за указанный день (одним запросом).
-- 5) Вывести ФИО пассажира, который провел в полетах наибольшее количество часов и наименьшее. По возможности сделать это одним запросом.
-- 6) Для каждого пилота вывести цепчку городов, по которым он летал. Пример:
-- Иванов Иван Иванович | Казань - Москва - Париж - Чебоксары.
--
-- Названия таблиц и колонок должны быть на английском языке (без использования транслита)

-- 1

CREATE TYPE ticket_class AS ENUM ('First Class', 'Business Class', 'Economy Class');
CREATE TYPE type_crew AS ENUM ('Pilot', 'Stewardess', 'Engineer');


CREATE TABLE airport(
    id     serial primary key,
    country text,
    address text
);


CREATE TABLE plane(
    id     serial primary key,
    company text,
    name text,
    capacity_crew int,
    capacity_passengers int
);

CREATE TABLE passenger(
    id  serial primary key,
    fio text,
    date_of_birth timestamp,
    contact_number text,
    country text,
    address text
);

CREATE TABLE flight(
    id     serial primary key,
    departure_date timestamp,
    arrival_date timestamp,
    departure_airport serial references airport(id),
    arrival_airport serial references airport(id),
    aircraft serial references plane(id),
    CHECK (departure_date < arrival_date)
);


CREATE TABLE ticket(
    id     serial primary key,
    passenger serial references passenger(id),
    flight serial references flight(id),
    cost float,
    class ticket_class
);


CREATE TABLE crew(
    id  serial primary key,
    fio text,
    contact_number text,
    type type_crew,
    aircraft serial references plane(id)
);



-- 2


INSERT INTO airport(country, address)
    values ('Russia', 'Аэропорт Казань'),
           ('USA', 'Международный аэропорт Маккаран'),
           ('Russia', 'Шереметьево'),
           ('Canada', 'Charlottetown Airport'),
           ('England', 'Аэропорт Лондон Саутенд');

INSERT INTO plane(company, name, capacity_crew, capacity_passengers)
    values ('Аэрофлот', 'Туполев Ту-204', 10, 110),
           ('Победа', 'Аэробус Airbus A310', 8, 80),
           ('Ямал', 'ИЛ-96-300', 12, 100),
           ('Смартавиа', 'Ильюшин ИЛ-86', 12, 150),
           ('Смартавиа', 'Туполев Ту-204', 20, 200);

INSERT INTO passenger(fio, date_of_birth, contact_number, country, address)
    values ('Ференец Александр Андреевич', '1999-06-22 19:10:25-07', '+7 927 932 32 54', 'Russia', 'деревня Универсиады, 16A, Казань'),
           ('Абрамский Михаил Михайлович', '2006-06-22 19:10:25-07', '+7 927 932 32 54', 'Russia', 'деревня Универсиады, 16A, Казань'),
           ('Селянцев Владислав Андреевич', '2003-06-22 19:10:25-07', '+7 927 932 32 54', 'Russia', 'деревня Универсиады, 16A, Казань'),
           ('Ярулин Данис Ралифович', '2003-06-22 19:10:25-07', '+7 927 932 32 54', 'Russia', 'деревня Универсиады, 16A, Казань'),
           ('Дмитриева Камила Тимуровна', '2003-06-22 19:10:25-07', '+7 927 932 32 54', 'Russia', 'деревня Универсиады, 16A, Казань');

INSERT INTO crew(fio, contact_number, type)
    values ('Петров Петр Петрович', '+7 875 678 87 67', 'Engineer'),
           ('Иванов Иван Иванович', '+7 875 678 87 67', 'Stewardess'),
           ('Андреев Андрей Андреевич', '+7 875 678 87 67', 'Pilot'),
           ('Мамонтов Петр Петрович', '+7 875 678 87 67', 'Pilot'),
           ('Скамова Руслана Петровна', '+7 875 678 87 67', 'Engineer');

INSERT INTO flight(departure_date, arrival_date, departure_airport, arrival_airport, aircraft)
    values ('1999-06-22 19:10:25', '1999-06-23 3:10:25', 1, 2, 1),
           ('2000-06-22 19:10:25', '2000-07-23 3:10:25', 2, 1, 1),
           ('2022-11-22 03:10:00', '2022-11-22 19:10:00', 4, 5, 3),
           ('2022-11-23 10:10:00', '2022-11-23 13:10:00', 5, 2, 1),
           ('2022-11-23 15:10:00', '2022-11-23 21:10:00', 2, 1, 5),
           ('1999-12-22 19:10:25', '1999-12-24 3:10:25', 4, 2, 3),
           ('2024-06-22 09:00:00', '2024-06-23 15:10:00', 1, 2, 1),
           ('1999-06-22 19:10:25', '1999-06-23 3:10:25', 3, 2, 2),
           ('1999-06-22 19:10:25', '1999-06-23 3:10:25', 5, 2, 1),
           ('1999-06-22 19:10:25', '1999-06-23 3:10:25', 4, 2, 4);


INSERT INTO ticket(passenger_id, flight_id, cost, class)
    values (1, 1, 300, 'Business Class'),
           (1, 2, 300, 'Business Class'),
           (1, 3, 300, 'Business Class'),
           (1, 4, 300, 'Business Class'),
           (1, 5, 300, 'Business Class'),
           (1, 6, 300, 'Business Class'),
           (1, 7, 300, 'First Class'),
           (2, 1, 300, 'First Class'),
           (2, 1, 300, 'First Class'),
           (2, 1, 300, 'First Class'),
           (3, 1, 300, 'Economy Class'),
           (4, 1, 300, 'Economy Class'),
           (5, 1, 300, 'Economy Class'),
           (5, 1, 300, 'Economy Class');



-- 3 


SELECT id, max(arrival_date - flight.departure_date)
FROM flight
group by id limit 1


-- 4

select airport.id, airport.address, flight.departure_date,
    count(flight.departure_airport)
from airport
        join flight on flight.departure_airport = airport.id
        where departure_date <= '1999-06-22 23:59:59' and departure_date >= '1999-06-22 00:00:00'
group by airport.id, flight.departure_date;

-- 5

SELECT passenger_id, sum(hours_in_fly) as time
FROM ticket
JOIN flight f on f.id = ticket.flight_id
group by passenger_id ORDER BY time DESC

-- 6

-- нету




