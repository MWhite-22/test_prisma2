-- CreateEnum
CREATE TYPE "TicketStage" AS ENUM ('CREATED', 'RECEIVED', 'SCHEDULED', 'COMPLETED', 'CLOSED');

-- CreateEnum
CREATE TYPE "TicketActivityType" AS ENUM ('STAGE_UPDATE', 'NOTE');

-- CreateTable
CREATE TABLE "building" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "addressStreet1" TEXT NOT NULL,
    "addressStreet2" TEXT,
    "addressCity" TEXT NOT NULL,
    "addressState" TEXT NOT NULL,
    "addressZip" TEXT NOT NULL,
    "companyId" TEXT NOT NULL,
    "version" INTEGER NOT NULL,
    "createdDate" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdById" TEXT NOT NULL,
    "updatedDate" TIMESTAMPTZ(6),
    "updatedById" TEXT,
    "deletedDate" TIMESTAMPTZ(6),
    "deletedById" TEXT,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "company" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "version" INTEGER NOT NULL,
    "createdDate" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdById" TEXT NOT NULL,
    "updatedDate" TIMESTAMPTZ(6),
    "updatedById" TEXT,
    "deletedDate" TIMESTAMPTZ(6),
    "deletedById" TEXT,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ticket" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "stage" "TicketStage" NOT NULL DEFAULT E'CREATED',
    "buildingId" TEXT NOT NULL,
    "version" INTEGER NOT NULL,
    "createdDate" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdById" TEXT NOT NULL,
    "updatedDate" TIMESTAMPTZ(6),
    "updatedById" TEXT,
    "deletedDate" TIMESTAMPTZ(6),
    "deletedById" TEXT,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ticketActivity" (
    "id" TEXT NOT NULL,
    "type" "TicketActivityType" NOT NULL DEFAULT E'NOTE',
    "content" TEXT NOT NULL,
    "ticketId" TEXT NOT NULL,
    "createdDate" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdById" TEXT NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user" (
    "id" TEXT NOT NULL,
    "nameFirst" TEXT NOT NULL,
    "nameLast" TEXT NOT NULL,
    "phoneCell" TEXT,
    "isAdmin" BOOLEAN NOT NULL DEFAULT false,
    "version" INTEGER NOT NULL,
    "createdDate" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdById" TEXT NOT NULL,
    "updatedDate" TIMESTAMPTZ(6),
    "updatedById" TEXT,
    "deletedDate" TIMESTAMPTZ(6),
    "deletedById" TEXT,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "linkTable_user_company" (
    "id" TEXT NOT NULL,
    "job_title" TEXT NOT NULL,
    "emailCompany" TEXT NOT NULL,
    "phoneCompany" TEXT,
    "defaultProfile" BOOLEAN NOT NULL DEFAULT false,
    "userId" TEXT NOT NULL,
    "companyId" TEXT NOT NULL,
    "version" INTEGER NOT NULL,
    "createdDate" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdById" TEXT NOT NULL,
    "updatedDate" TIMESTAMPTZ(6),
    "updatedById" TEXT,
    "deletedDate" TIMESTAMPTZ(6),
    "deletedById" TEXT,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_login" (
    "userId" TEXT NOT NULL,
    "emailPersonal" TEXT NOT NULL,
    "username" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "isEmailConfirmed" BOOLEAN NOT NULL DEFAULT false,
    "isLocked" BOOLEAN NOT NULL DEFAULT false,
    "createdDate" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdById" TEXT NOT NULL,

    PRIMARY KEY ("userId")
);

-- CreateIndex
CREATE UNIQUE INDEX "Unique_Addresses" ON "building"("addressStreet1", "addressStreet2", "addressCity", "addressState", "addressZip");

-- CreateIndex
CREATE UNIQUE INDEX "linkTable_user_company.emailCompany_unique" ON "linkTable_user_company"("emailCompany");

-- CreateIndex
CREATE UNIQUE INDEX "One_User_Per_Company" ON "linkTable_user_company"("userId", "companyId");

-- CreateIndex
CREATE UNIQUE INDEX "user_login.emailPersonal_unique" ON "user_login"("emailPersonal");

-- CreateIndex
CREATE UNIQUE INDEX "user_login.username_unique" ON "user_login"("username");

-- AddForeignKey
ALTER TABLE "building" ADD FOREIGN KEY ("companyId") REFERENCES "company"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ticket" ADD FOREIGN KEY ("buildingId") REFERENCES "building"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ticketActivity" ADD FOREIGN KEY ("ticketId") REFERENCES "ticket"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "linkTable_user_company" ADD FOREIGN KEY ("userId") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "linkTable_user_company" ADD FOREIGN KEY ("companyId") REFERENCES "company"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_login" ADD FOREIGN KEY ("userId") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE;
