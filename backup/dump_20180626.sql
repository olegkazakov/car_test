--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.9
-- Dumped by pg_dump version 9.6.9

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: car; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.car (
    id integer NOT NULL,
    created_dt timestamp with time zone DEFAULT now() NOT NULL,
    car_class_id integer DEFAULT 2 NOT NULL,
    model_id integer NOT NULL,
    condition character varying(20) DEFAULT 'new'::character varying NOT NULL,
    prod_year integer DEFAULT 2018 NOT NULL,
    title character varying(256) NOT NULL,
    number character varying(20) NOT NULL,
    status character varying(20) DEFAULT 'free'::character varying,
    mileage_today numeric(11,4) DEFAULT 0 NOT NULL,
    mileage_total numeric(15,4) DEFAULT 0 NOT NULL,
    option_baby_chair_is smallint DEFAULT 0 NOT NULL,
    deleted_is boolean DEFAULT false NOT NULL,
    deleted_dt timestamp with time zone,
    updated_dt timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.car OWNER TO postgres;

--
-- Name: car_class; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.car_class (
    id integer NOT NULL,
    created_dt timestamp with time zone DEFAULT now(),
    name character varying(20) NOT NULL,
    title character varying(256),
    description character varying(1024),
    class_koef numeric(7,4),
    option_baby_chair_tariff numeric(11,4) DEFAULT 0 NOT NULL,
    option_baby_chair_day_max numeric(11,4) DEFAULT 0,
    deleted_is boolean DEFAULT false NOT NULL,
    deleted_dt timestamp with time zone,
    updated_dt timestamp with time zone DEFAULT now()
);


ALTER TABLE public.car_class OWNER TO postgres;

--
-- Name: car_class_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.car_class_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.car_class_id_seq OWNER TO postgres;

--
-- Name: car_class_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.car_class_id_seq OWNED BY public.car_class.id;


--
-- Name: car_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.car_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.car_id_seq OWNER TO postgres;

--
-- Name: car_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.car_id_seq OWNED BY public.car.id;


--
-- Name: car_model; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.car_model (
    id integer NOT NULL,
    created_dt timestamp with time zone DEFAULT now(),
    title character varying(256) NOT NULL,
    manufacturer character varying(256) NOT NULL,
    class_id integer DEFAULT 1 NOT NULL,
    modification numeric(5,2) DEFAULT 1.4 NOT NULL,
    body_type character varying(20) NOT NULL,
    doors_number integer DEFAULT 4 NOT NULL,
    engine_volume integer DEFAULT 1500 NOT NULL,
    power integer DEFAULT 110 NOT NULL,
    prod_start_year integer DEFAULT 2010,
    prod_ens_year integer,
    deleted_is boolean DEFAULT false NOT NULL,
    deleted_dt timestamp with time zone,
    updated_dt timestamp with time zone DEFAULT now() NOT NULL,
    seats_number integer DEFAULT 4 NOT NULL,
    country character varying(256) NOT NULL
);


ALTER TABLE public.car_model OWNER TO postgres;

--
-- Name: car_model_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.car_model_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.car_model_id_seq OWNER TO postgres;

--
-- Name: car_model_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.car_model_id_seq OWNED BY public.car_model.id;


--
-- Name: car_rent; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.car_rent (
    id integer NOT NULL,
    created_dt timestamp with time zone DEFAULT now() NOT NULL,
    user_id integer NOT NULL,
    car_id integer,
    status character varying(20) DEFAULT 'reserve'::character varying NOT NULL,
    reserve_begin_dt timestamp with time zone DEFAULT now() NOT NULL,
    reserve_end_dt timestamp with time zone,
    reserve_price_time numeric(15,4) DEFAULT 0 NOT NULL,
    reserve_price numeric(15,4) DEFAULT 0 NOT NULL,
    tariff_id integer NOT NULL,
    inspect_begin_dt timestamp with time zone,
    inspect_end_dt timestamp with time zone,
    inspect_price numeric(15,4) DEFAULT 0 NOT NULL,
    trip_begin_dt timestamp with time zone,
    trip_end_dt timestamp with time zone,
    trip_replay_dt timestamp with time zone,
    trip_time_total integer DEFAULT 0 NOT NULL,
    trip_dist integer DEFAULT 0 NOT NULL,
    trip_dist_price numeric(15,4) DEFAULT 0 NOT NULL,
    trip_price numeric(15,4) DEFAULT 0 NOT NULL,
    park_begin_dt timestamp with time zone,
    park_end_dt timestamp with time zone,
    park_replay_dt timestamp with time zone,
    park_time_total integer DEFAULT 0 NOT NULL,
    park_price numeric(15,4) DEFAULT 0 NOT NULL,
    total_time integer DEFAULT 0 NOT NULL,
    total_price numeric(15,4) DEFAULT 0 NOT NULL,
    option_baby_chair_price numeric(15,4) DEFAULT 0 NOT NULL,
    deleted_is boolean DEFAULT false NOT NULL,
    deleted_dt timestamp with time zone,
    updated_dt timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.car_rent OWNER TO postgres;

--
-- Name: car_rent_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.car_rent_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.car_rent_id_seq OWNER TO postgres;

--
-- Name: car_rent_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.car_rent_id_seq OWNED BY public.car_rent.id;


--
-- Name: car_rent_tariff; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.car_rent_tariff (
    id integer NOT NULL,
    created_dt timestamp with time zone DEFAULT now() NOT NULL,
    car_class_id integer DEFAULT 0 NOT NULL,
    title character varying(50) NOT NULL,
    description character varying(1024) NOT NULL,
    reserve_free_period integer DEFAULT 20 NOT NULL,
    reserve_minute_price numeric(11,4) DEFAULT 2 NOT NULL,
    reserve_free_time_start time with time zone DEFAULT '23:00:00+03'::time with time zone NOT NULL,
    reserve_free_time_end time with time zone DEFAULT '07:00:00+03'::time with time zone NOT NULL,
    inspect_free_period integer DEFAULT 7 NOT NULL,
    inspect_minute_price numeric(11,4) DEFAULT 2 NOT NULL,
    trip_minute_price numeric(11,4) DEFAULT 8 NOT NULL,
    trip_base_dist numeric(11,3) DEFAULT 70 NOT NULL,
    trip_dist_km_price numeric(11,4) DEFAULT 10 NOT NULL,
    rent_time_max_price numeric(11,4) DEFAULT 2700 NOT NULL,
    park_minute_price numeric(11,4) DEFAULT 2 NOT NULL,
    park_free_time_start time with time zone DEFAULT '23:00:00+03'::time with time zone NOT NULL,
    park_free_time_end time with time zone DEFAULT '07:00:00+03'::time with time zone NOT NULL,
    car_class_koef_is smallint DEFAULT 1 NOT NULL,
    user_privilege_koef_is smallint DEFAULT 1,
    user_group_koef_is smallint DEFAULT 1 NOT NULL,
    user_min_balance numeric(11,4) DEFAULT 0 NOT NULL,
    deleted_is boolean DEFAULT false NOT NULL,
    deketed_dt timestamp with time zone,
    updated_dt timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.car_rent_tariff OWNER TO postgres;

--
-- Name: car_rent_tariff_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.car_rent_tariff_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.car_rent_tariff_id_seq OWNER TO postgres;

--
-- Name: car_rent_tariff_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.car_rent_tariff_id_seq OWNED BY public.car_rent_tariff.id;


--
-- Name: user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."user" (
    id bigint NOT NULL,
    created_dt timestamp without time zone NOT NULL,
    login character varying(256) NOT NULL,
    email character varying(256) NOT NULL,
    password character varying(256) NOT NULL,
    name character varying(256) NOT NULL,
    second_name character varying(256),
    group_id smallint NOT NULL,
    phone character varying(256) NOT NULL,
    account numeric(15,4) DEFAULT 0 NOT NULL,
    privilege_koef numeric(7,4) DEFAULT 1 NOT NULL,
    deleted_is boolean DEFAULT false NOT NULL,
    deleted_dt timestamp without time zone,
    updated_dt timestamp with time zone,
    last_login_dt timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public."user" OWNER TO postgres;

--
-- Name: user_group; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_group (
    id integer NOT NULL,
    created_dt timestamp with time zone DEFAULT now() NOT NULL,
    title character varying(256) NOT NULL,
    description character varying(1024),
    group_koef numeric(7,4) DEFAULT 1 NOT NULL,
    deleted_is boolean DEFAULT false NOT NULL,
    deleted_dt timestamp with time zone,
    updated_dt timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.user_group OWNER TO postgres;

--
-- Name: user_group_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_group_id_seq OWNER TO postgres;

--
-- Name: user_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_group_id_seq OWNED BY public.user_group.id;


--
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_id_seq OWNER TO postgres;

--
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_id_seq OWNED BY public."user".id;


--
-- Name: car id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.car ALTER COLUMN id SET DEFAULT nextval('public.car_id_seq'::regclass);


--
-- Name: car_class id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.car_class ALTER COLUMN id SET DEFAULT nextval('public.car_class_id_seq'::regclass);


--
-- Name: car_model id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.car_model ALTER COLUMN id SET DEFAULT nextval('public.car_model_id_seq'::regclass);


--
-- Name: car_rent id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.car_rent ALTER COLUMN id SET DEFAULT nextval('public.car_rent_id_seq'::regclass);


--
-- Name: car_rent_tariff id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.car_rent_tariff ALTER COLUMN id SET DEFAULT nextval('public.car_rent_tariff_id_seq'::regclass);


--
-- Name: user id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user" ALTER COLUMN id SET DEFAULT nextval('public.user_id_seq'::regclass);


--
-- Name: user_group id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_group ALTER COLUMN id SET DEFAULT nextval('public.user_group_id_seq'::regclass);


--
-- Data for Name: car; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.car (id, created_dt, car_class_id, model_id, condition, prod_year, title, number, status, mileage_today, mileage_total, option_baby_chair_is, deleted_is, deleted_dt, updated_dt) FROM stdin;
3	2018-06-23 18:14:37.247+03	6	5	'new'	2018	Porsche 4 E-Hybrid Sport Turismo (971)	А999БВ777	'inspect'	0.0000	225.0000	0	f	\N	2018-06-26 12:05:54.277621+03
2	2018-06-23 18:13:00.118+03	4	4	'good'	2014	Toyota Camry 2.5 (XV50(2014))	Н225ВХ777\r\n	'reserved'	0.0000	14421.0000	0	f	\N	2018-06-26 12:05:54.277621+03
1	2018-06-23 18:10:15.122+03	2	2	'good'	2018	KIA Rio 1.4 MPI (IV)	К050АС777	'free'	116.0000	22600.5000	1	f	\N	2018-06-26 12:05:54.277621+03
\.


--
-- Data for Name: car_class; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.car_class (id, created_dt, name, title, description, class_koef, option_baby_chair_tariff, option_baby_chair_day_max, deleted_is, deleted_dt, updated_dt) FROM stdin;
9	2018-06-23 13:55:57.774+03	S	Sport coupés	спорткупе	1.6000	0.0000	0.0000	f	\N	2018-06-23 18:03:08.566689+03
6	2018-06-23 13:52:45.197+03	F	Luxury cars	представительские автомобили	2.0000	5.0000	500.0000	f	\N	2018-06-23 18:03:08.566689+03
1	2018-06-23 13:45:59.798+03	A	Mini cars 	микроавтомобили	0.9000	2.0000	300.0000	f	\N	2018-06-23 18:03:08.566689+03
8	2018-06-23 13:54:49.324+03	M	Multi purpose cars	минивэны и УПВ	1.7500	2.0000	300.0000	f	\N	2018-06-23 18:03:08.566689+03
4	2018-06-23 13:49:10.785+03	D	Larger cars 	большие семейные автомобили	1.2500	2.0000	300.0000	f	\N	2018-06-23 18:03:08.566689+03
5	2018-06-23 13:50:21.61+03	E	Executive cars 	«бизнес-класс»	1.5000	3.0000	400.0000	f	\N	2018-06-23 18:03:08.566689+03
7	2018-06-23 13:53:53.634+03	J	Sports utility 	SUV, «внедорожники»	1.4500	3.0000	400.0000	f	\N	2018-06-23 18:03:08.566689+03
2	2018-06-23 13:47:57.498+03	B	Small cars	малые автомобили	1.0000	2.0000	300.0000	f	\N	2018-06-23 18:03:08.566689+03
3	2018-06-23 13:48:29.93+03	C	Medium cars 	европейский «средний класс»	1.1000	2.0000	300.0000	f	\N	2018-06-23 18:03:08.566689+03
\.


--
-- Name: car_class_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.car_class_id_seq', 7, true);


--
-- Name: car_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.car_id_seq', 1, false);


--
-- Data for Name: car_model; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.car_model (id, created_dt, title, manufacturer, class_id, modification, body_type, doors_number, engine_volume, power, prod_start_year, prod_ens_year, deleted_is, deleted_dt, updated_dt, seats_number, country) FROM stdin;
2	2018-06-23 16:40:27.728+03	KIA Rio	Kia Motors	2	1.40	седан	4	1368	100	2017	\N	f	\N	2018-06-23 16:42:06.692941+03	5	Россия
1	2018-06-23 16:29:40.339+03	Smart Fortwo	Daimler AG (Mercedes-Benz Cars Group)	1	0.90	купе	2	898	90	2014	\N	f	\N	2018-06-23 16:33:57.008547+03	2	Германия
3	2018-06-23 16:43:53.946+03	Hyundai Accent (RB)	Hyundai Motor Company	3	1.40	седан	4	1396	108	2010	\N	f	\N	2018-06-23 16:45:52.027991+03	5	Южная Корея
4	2018-06-23 16:49:01.719+03	Toyota (XV50)	Toyota Motor Corporation	4	2.50	седан	4	2494	181	2014	2018	f	\N	2018-06-23 16:52:12.590777+03	5	Япония
5	2018-06-23 16:54:53.464+03	Porsche Panamera (971)	Porsche AG	6	2.90	универсал	5	2894	330	2017	\N	f	\N	2018-06-23 16:57:10.157535+03	5	Германия
\.


--
-- Name: car_model_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.car_model_id_seq', 1, false);


--
-- Data for Name: car_rent; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.car_rent (id, created_dt, user_id, car_id, status, reserve_begin_dt, reserve_end_dt, reserve_price_time, reserve_price, tariff_id, inspect_begin_dt, inspect_end_dt, inspect_price, trip_begin_dt, trip_end_dt, trip_replay_dt, trip_time_total, trip_dist, trip_dist_price, trip_price, park_begin_dt, park_end_dt, park_replay_dt, park_time_total, park_price, total_time, total_price, option_baby_chair_price, deleted_is, deleted_dt, updated_dt) FROM stdin;
1	2018-06-26 08:25:00.001+03	1	1	finished	2018-06-26 08:25:00.292+03	2018-06-26 08:50:50.394+03	25.0000	10.0000	1	2018-06-26 08:50:52.753+03	2018-06-26 08:55:03.16+03	0.0000	2018-06-26 08:55:03.516+03	2018-06-26 09:20:02.548+03	2018-06-26 09:11:35.589+03	19	78	80.0000	152.0000	2018-06-26 09:05:05.196+03	2018-06-26 09:11:34.517+03	\N	7	14.0000	55	364.0000	110.0000	f	\N	2018-06-26 12:08:08.528151+03
2	2018-06-26 11:48:24.590285+03	2	1	finished	2018-06-26 11:43:05.557+03	2018-06-26 11:46:14.292+03	3.0000	0.0000	2	2018-06-26 11:46:51.923+03	2018-06-26 12:05:56.518+03	4.4000	2018-06-26 12:05:57.456+03	2018-06-26 12:34:05.892+03	\N	29	38	0.0000	255.2000	\N	\N	\N	0	0.0000	51	259.6000	0.0000	f	\N	2018-06-26 12:08:08.528151+03
4	2018-06-26 12:03:34.350639+03	3	2	inspect	2018-06-26 11:45:48.973+03	2018-06-26 12:09:53.637+03	25.0000	13.0625	3	2018-06-26 12:09:54.248+03	\N	0.0000	\N	\N	\N	0	0	0.0000	0.0000	\N	\N	\N	0	0.0000	0	0.0000	0.0000	f	\N	2018-06-26 12:08:08.528151+03
\.


--
-- Name: car_rent_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.car_rent_id_seq', 4, true);


--
-- Data for Name: car_rent_tariff; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.car_rent_tariff (id, created_dt, car_class_id, title, description, reserve_free_period, reserve_minute_price, reserve_free_time_start, reserve_free_time_end, inspect_free_period, inspect_minute_price, trip_minute_price, trip_base_dist, trip_dist_km_price, rent_time_max_price, park_minute_price, park_free_time_start, park_free_time_end, car_class_koef_is, user_privilege_koef_is, user_group_koef_is, user_min_balance, deleted_is, deketed_dt, updated_dt) FROM stdin;
2	2018-06-24 14:41:39.020677+03	3	Base dist C	Тарификация по километражу для С класса 	20	2.0000	23:00:00+03	07:00:00+03	7	2.0000	8.0000	70.000	10.0000	2700.0000	2.0000	23:00:00+03	07:00:00+03	1	0	1	0.0000	f	\N	2018-06-26 12:08:44.273574+03
1	2018-06-24 14:41:39.020677+03	2	Base	Базовый тариф для автомобилей класса В	20	2.0000	23:00:00+03	07:00:00+03	7	2.0000	8.0000	70.000	10.0000	2700.0000	2.0000	23:00:00+03	07:00:00+03	1	1	0	0.0000	f	\N	2018-06-26 12:08:44.273574+03
3	2018-06-26 11:51:24.405835+03	4	Standart D	D стандарт	10	3.0000	23:00:00+03	07:00:00+03	8	2.0000	10.0000	70.000	10.0000	3500.0000	2.0000	23:00:00+03	07:00:00+03	1	1	1	0.0000	f	\N	2018-06-26 12:08:44.273574+03
\.


--
-- Name: car_rent_tariff_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.car_rent_tariff_id_seq', 8, true);


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."user" (id, created_dt, login, email, password, name, second_name, group_id, phone, account, privilege_koef, deleted_is, deleted_dt, updated_dt, last_login_dt) FROM stdin;
1	2018-06-23 12:18:10.788	admin	admin@test.com	5701e1fc38a45821bc7687a3d8530720	admin	\N	1	89999876543	0.0000	1.0000	f	\N	\N	2018-06-23 12:18:14.95153+03
2	2018-06-23 13:00:56.06	user1	user1@test.com	17332cff3266db1c4381de7e883a71f0	Ivan	Petrov	1	89751234567	500.0000	0.9000	f	\N	\N	2018-06-23 13:02:27.906101+03
3	2018-06-23 13:03:16.566	company1_ceo	ceo@company1.com	03d7d75302d654dce756c66325a25f8e	Сергей	Филатов	2	84991234567	10000.0000	0.9500	f	\N	\N	2018-06-23 13:05:25.3483+03
\.


--
-- Data for Name: user_group; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_group (id, created_dt, title, description, group_koef, deleted_is, deleted_dt, updated_dt) FROM stdin;
1	2018-06-23 11:45:29.607+03	individual	Физ. лица	1.0000	f	\N	2018-06-23 12:11:56.0288+03
2	2018-06-23 11:47:09.827+03	corporate	Юридические лица	1.1000	f	\N	2018-06-23 12:11:56.0288+03
\.


--
-- Name: user_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_group_id_seq', 1, false);


--
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_id_seq', 4, false);


--
-- Name: car_class car_class_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.car_class
    ADD CONSTRAINT car_class_pkey PRIMARY KEY (id);


--
-- Name: car_model car_model_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.car_model
    ADD CONSTRAINT car_model_pkey PRIMARY KEY (id);


--
-- Name: car car_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.car
    ADD CONSTRAINT car_pkey PRIMARY KEY (id);


--
-- Name: car_rent car_rent_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.car_rent
    ADD CONSTRAINT car_rent_pkey PRIMARY KEY (id);


--
-- Name: car_rent_tariff car_rent_tariff_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.car_rent_tariff
    ADD CONSTRAINT car_rent_tariff_pkey PRIMARY KEY (id);


--
-- Name: user_group user_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_group
    ADD CONSTRAINT user_group_pkey PRIMARY KEY (id);


--
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- Name: car_class_id_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX car_class_id_uindex ON public.car_class USING btree (id);


--
-- Name: car_class_name_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX car_class_name_uindex ON public.car_class USING btree (name);


--
-- Name: car_condition_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX car_condition_index ON public.car USING btree (condition);


--
-- Name: car_id_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX car_id_uindex ON public.car USING btree (id);


--
-- Name: car_model_doors_number_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX car_model_doors_number_index ON public.car_model USING btree (doors_number);


--
-- Name: car_model_id_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX car_model_id_uindex ON public.car_model USING btree (id);


--
-- Name: car_model_sets_number_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX car_model_sets_number_index ON public.car_model USING btree (seats_number);


--
-- Name: car_rent_id_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX car_rent_id_uindex ON public.car_rent USING btree (id);


--
-- Name: car_rent_status_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX car_rent_status_index ON public.car_rent USING btree (status);


--
-- Name: car_rent_tariff_class_koef_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX car_rent_tariff_class_koef_index ON public.car_rent_tariff USING btree (car_class_koef_is);


--
-- Name: car_rent_tariff_id_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX car_rent_tariff_id_uindex ON public.car_rent_tariff USING btree (id);


--
-- Name: car_rent_tariff_user_group_koef_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX car_rent_tariff_user_group_koef_index ON public.car_rent_tariff USING btree (user_group_koef_is);


--
-- Name: car_rent_tariff_user_privilege_koef_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX car_rent_tariff_user_privilege_koef_index ON public.car_rent_tariff USING btree (user_privilege_koef_is);


--
-- Name: car_status_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX car_status_index ON public.car USING btree (status);


--
-- Name: user_deleted_is_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_deleted_is_index ON public."user" USING btree (deleted_is);


--
-- Name: user_email_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX user_email_uindex ON public."user" USING btree (email);


--
-- Name: user_group_deleted_is_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_group_deleted_is_index ON public.user_group USING btree (deleted_is);


--
-- Name: user_group_id_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX user_group_id_uindex ON public.user_group USING btree (id);


--
-- Name: user_id_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX user_id_uindex ON public."user" USING btree (id);


--
-- Name: user_login_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX user_login_uindex ON public."user" USING btree (login);


--
-- Name: car car_class_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.car
    ADD CONSTRAINT car_class_id_fk FOREIGN KEY (car_class_id) REFERENCES public.car_class(id);


--
-- Name: car_model car_model_class_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.car_model
    ADD CONSTRAINT car_model_class_id_fk FOREIGN KEY (class_id) REFERENCES public.car_class(id);


--
-- Name: car car_model_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.car
    ADD CONSTRAINT car_model_id_fk FOREIGN KEY (model_id) REFERENCES public.car_model(id);


--
-- Name: car_rent car_rent_car_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.car_rent
    ADD CONSTRAINT car_rent_car_id_fk FOREIGN KEY (car_id) REFERENCES public.car(id);


--
-- Name: car_rent_tariff car_rent_tariff_class_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.car_rent_tariff
    ADD CONSTRAINT car_rent_tariff_class_id_fk FOREIGN KEY (car_class_id) REFERENCES public.car_class(id);


--
-- Name: car_rent car_rent_tariff_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.car_rent
    ADD CONSTRAINT car_rent_tariff_id_fk FOREIGN KEY (tariff_id) REFERENCES public.car_rent_tariff(id);


--
-- Name: car_rent car_rent_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.car_rent
    ADD CONSTRAINT car_rent_user_id_fk FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: user user_group_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_group_id_fk FOREIGN KEY (group_id) REFERENCES public.user_group(id);


--
-- PostgreSQL database dump complete
--

