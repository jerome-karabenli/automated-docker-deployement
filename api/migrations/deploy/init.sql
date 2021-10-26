-- Deploy ochalet:init to pg

BEGIN;

CREATE TABLE "user" (
	"id" int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	"firstname" text NOT NULL,
    "lastname" text NOT NULL,
    "email" text NOT NULL,
    "phone" text,
    "birth_date" timestamptz,
    "zip_code" text,
    "city_name" text,
    "country" text,
    "street_name" text,
    "street_number" text,
    "password" text NOT NULL,
    "role" text NOT NULL DEFAULT 'user'
);

CREATE TABLE "location" (
	"id" int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	"name" text NOT NULL,
    "picture" text NOT NULL
);

CREATE TABLE "offer" (
	"id" int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	"title" text NOT NULL,
    "body" text NOT NULL,
    "zip_code" text NOT NULL,
    "city_name" text NOT NULL,
    "country" text NOT NULL,
    "street_name" text NOT NULL,
    "street_number" text NOT NULL,
    "latitude" text,
    "longitude" text,
    "price_ht" int NOT NULL,
    "tax" int NOT NULL,
    "main_picture" text NOT NULL,
    "galery_picture_1" text,
    "galery_picture_2" text,
    "galery_picture_3" text,
    "galery_picture_4" text,
    "galery_picture_5" text,
    "offer_status" boolean NOT NULL DEFAULT 'false',
    "location_id" INTEGER NOT NULL REFERENCES "location"("id")
);

CREATE TABLE "comment" (
	"id" int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	"body" text NOT NULL,
    "note" int NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    "user_id" INT NOT NULL REFERENCES "user"("id"),
    "offer_id" INT NOT NULL REFERENCES "offer"("id")
);

CREATE TABLE "message" (
	"id" int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	-- firstname text ,
	-- lastname text ,
	-- email text ,
	"reservation_start" TIMESTAMPTZ,
	"reservation_end" TIMESTAMPTZ,
    "nb_persons" int,
    "body" text NOT NULL,
    "created_at" timestamptz NOT NULL DEFAULT NOW (),
    "message_status" boolean NOT NULL DEFAULT 'true',
    "offer_id" INT NOT NULL REFERENCES "offer"("id"),
    "user_id" INTEGER NOT NULL REFERENCES "user"("id")
);

CREATE TABLE "booking" (
	"id" int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	"reservation_start" timestamptz NOT NULL,
	"reservation_end" timestamptz NOT NULL,
    "reservation_status" boolean NOT NULL DEFAULT 'false',
    "message" text,
    "user_id" INT NOT NULL REFERENCES "user"("id"),
    "offer_id" INT NOT NULL REFERENCES "offer"("id")
);

COMMIT;
