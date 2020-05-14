CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE TABLE "public"."dummy"("id" uuid NOT NULL DEFAULT gen_random_uuid(), PRIMARY KEY ("id") );
