CREATE EXTENSION postgis;

CREATE SCHEMA data;

CREATE SEQUENCE data.observations_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1000;

CREATE SEQUENCE observed_properties_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

CREATE TABLE public.observed_properties
(
   id integer NOT NULL default nextval('observed_properties_id_seq'),
   name character varying,
   def character varying NOT NULL,
   description character varying,
   PRIMARY KEY (id),
   UNIQUE (name),
   UNIQUE (def)
);

INSERT INTO public.observed_properties VALUES
(1, 'air-temperature',
    'urn:ogc:def:parameter:x-istsos:1.0:meteo:air:temperature',
    'Air temperature at 2 meters above terrain'),
(2, 'air-rainfall',
    'urn:ogc:def:parameter:x-istsos:1.0:meteo:air:rainfall',
    'Liquid precipitation or snow water equivalent'),
(3, 'air-relative-humidity',
    'urn:ogc:def:parameter:x-istsos:1.0:meteo:air:humidity:relative',
    'Absolute humidity relative to the maximum for that air'),
(4, 'air-wind-velocity',
    'urn:ogc:def:parameter:x-istsos:1.0:meteo:air:wind:velocity',
    'Wind speed at 1 meter above terrain'),
(5, 'solar-radiation',
    'urn:ogc:def:parameter:x-istsos:1.0:meteo:solar:radiation',
    'Direct radiation sum in spectrum rand'),
(6, 'river-height',
    'urn:ogc:def:parameter:x-istsos:1.0:river:water:height',
    ''),
(7, 'river-discharge',
    'urn:ogc:def:parameter:x-istsos:1.0:river:water:discharge',
    ''),
(8, 'soil-evapotranspiration',
    'urn:ogc:def:parameter:x-istsos:1.0:meteo:soil:evapotranspiration',
    ''),
(9, 'air-heatindex',
    'urn:ogc:def:parameter:x-istsos:1.0:meteo:air:heatindex',
    '');
SELECT pg_catalog.setval('observed_properties_id_seq', 9, true);

CREATE SEQUENCE uoms_id_uom_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

CREATE TABLE public.uoms
(
    id integer NOT NULL default nextval('uoms_id_uom_seq'),
    name character varying NOT NULL,
    description character varying,
    PRIMARY KEY (id),
    UNIQUE (name)
);

INSERT INTO uoms VALUES
    (0, 'null', ''),
    (1, 'mm', 'millimeter'),
    (2, '°C', 'Celsius degree'),
    (3, '%', 'percentage'),
    (4, 'm/s', 'metre per second'),
    (5, 'W/m2', 'Watt per square metre'),
    (6, '°F', 'Fahrenheit degree'),
    (7, 'm', 'metre'),
    (8, 'm3/s', 'cube meter per second'),
    (9, 'mm/h', 'evapotranspiration'),
    (10, 'g', 'gram'),
    (11, 'Kg', 'kilogram'),
    (12, 'ml', 'milliliter'),
    (13, 'l', 'liter');

SELECT pg_catalog.setval('uoms_id_uom_seq', 9, true);

CREATE SEQUENCE material_classes_id_mcl_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

CREATE TABLE public.material_classes
(
    id integer NOT NULL default nextval('material_classes_id_mcl_seq'),
    name character varying NOT NULL,
    definition character varying NOT NULL,
    description character varying,
    image character varying,
    PRIMARY KEY (id)
);

INSERT INTO material_classes VALUES
    (1,
        'soil',
        'http://www.opengis.net/def/material/OGC-OM/2.0/soil',
        '',
        '/img/materials/soil.png'),
    (2,
        'water',
        'http://www.opengis.net/def/material/OGC-OM/2.0/water',
        '',
        '/img/materials/water.png'),
    (3,
        'rock',
        'http://www.opengis.net/def/material/OGC-OM/2.0/rock',
        '',
        '/img/materials/rock.png'),
    (4,
        'tissue',
        'http://www.opengis.net/def/material/OGC-OM/2.0/tissue',
        '',
        '/img/materials/tissue.png'
    );

SELECT pg_catalog.setval('material_classes_id_mcl_seq', 4, true);


CREATE SEQUENCE methods_id_met_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

CREATE TABLE public.methods
(
    id integer NOT NULL default nextval('methods_id_met_seq'),
    name character varying NOT NULL,
    description character varying,
    PRIMARY KEY (id)
);

SELECT pg_catalog.setval('methods_id_met_seq', 1, true);

CREATE SEQUENCE offerings_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 10;

CREATE TABLE public.offerings
(
    id integer NOT NULL default nextval('offerings_id_seq'),
    data_table_exists boolean DEFAULT FALSE,
    offering_name character varying NOT NULL,
    procedure_name character varying NOT NULL,
    description_format character varying,
    foi_type character varying NOT NULL,
    sampled_foi character varying,
    fixed boolean DEFAULT FALSE,
    pt_begin timestamp with time zone,
    pt_end timestamp with time zone,
    rt_begin timestamp with time zone,
    rt_end timestamp with time zone,
    observed_area geometry,
    cached jsonb,
    config jsonb,
    PRIMARY KEY (id)
);

CREATE INDEX
   ON public.offerings USING btree (id ASC NULLS LAST);

CREATE SEQUENCE sensor_descriptions_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

CREATE TABLE public.sensor_descriptions
(
    id integer NOT NULL default nextval('sensor_descriptions_id_seq'),
    id_off integer NOT NULL,
    valid_time_begin timestamp with time zone,
    valid_time_end timestamp with time zone,
    data character varying,
    PRIMARY KEY (id),
    FOREIGN KEY (id_off) REFERENCES offerings (id)
        ON UPDATE NO ACTION ON DELETE CASCADE
);

CREATE INDEX
   ON public.sensor_descriptions USING btree (id_off ASC NULLS LAST);

CREATE SEQUENCE off_obs_prop_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

CREATE TABLE public.off_obs_prop
(
    id integer NOT NULL default nextval('off_obs_prop_id_seq'),
    id_off integer NOT NULL,
    id_opr integer NOT NULL,
    id_uom integer,
    observation_type character varying,
    col_name character varying,
    PRIMARY KEY (id),
    FOREIGN KEY (id_off) REFERENCES offerings (id)
        ON UPDATE NO ACTION ON DELETE CASCADE,
    FOREIGN KEY (id_opr) REFERENCES observed_properties (id)
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    FOREIGN KEY (id_uom) REFERENCES uoms (id)
        ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE INDEX
   ON public.off_obs_prop USING btree (id_off ASC NULLS LAST);

CREATE SEQUENCE off_obs_type_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

CREATE TABLE public.off_obs_type
(
    id integer NOT NULL default nextval('off_obs_type_id_seq'),
    id_off integer NOT NULL,
    observation_type character varying,
    PRIMARY KEY (id),
    FOREIGN KEY (id_off) REFERENCES offerings (id)
        ON UPDATE NO ACTION ON DELETE CASCADE
);

CREATE INDEX
   ON public.off_obs_type USING btree (id_off ASC NULLS LAST);

CREATE SEQUENCE specimen_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

CREATE TABLE public.specimens
(
  id integer NOT NULL DEFAULT nextval('specimen_id_seq'),
  description text,
  identifier text NOT NULL UNIQUE,
  name text,
  type text,
  sampled_feat text,
  id_mat_fk integer,
  id_met_fk integer,
  sampling_time timestamp with time zone,
  sampling_location geometry,
  processing_details jsonb,
  sampling_size_uom text,
  sampling_size double precision,
  current_location jsonb,
  specimen_type text,
  CONSTRAINT specimen_id_mat_fk_fkey FOREIGN KEY (id_mat_fk)
      REFERENCES material_classes (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT specimen_id_met_fk_fkey FOREIGN KEY (id_met_fk)
      REFERENCES methods (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE public.fois
(
   id serial NOT NULL,
   description character varying,
   identifier character varying NOT NULL,
   foi_name character varying,
   foi_type character varying,
   geom geometry,
   PRIMARY KEY (id),
   UNIQUE (identifier)
);

CREATE TABLE public.sampled_foi
(
    id integer NOT NULL,
    id_sam integer NOT NULL,
    PRIMARY KEY (id, id_sam),
    FOREIGN KEY (id) REFERENCES public.fois (id)
        ON UPDATE NO ACTION ON DELETE CASCADE,
    FOREIGN KEY (id_sam) REFERENCES public.fois (id)
        ON UPDATE NO ACTION ON DELETE CASCADE
);


INSERT INTO public.fois(
    description, identifier, foi_name, sampled_foi, foi_type, geom)
VALUES (
    'There is no value',
    'http://www.opengis.net/def/nil/OGC/0/inapplicable',
    'Inapplicable', NULL, NULL
),(
    'The correct value is not readily available to the sender of this data. Furthermore, a correct value may not exist',
    'http://www.opengis.net/def/nil/OGC/0/missing',
    'Missing', NULL, NULL
),(
    'The correct value is not known to, or not computable by, the sender of this data. However, the correct value probably exists',
    'http://www.opengis.net/def/nil/OGC/0/unknown',
    'Unknown', NULL, NULL
);
