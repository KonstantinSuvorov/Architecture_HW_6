CREATE TABLE IF NOT EXISTS `Appointment` (
	`id` int NOT NULL,
	`PatientId` int NOT NULL,
	`DoctorId` int NOT NULL,
	`TimeOfReceipt` datetime NOT NULL,
	`CabinetId` int,
	`IsCancelled` bit(1) DEFAULT '0',
	`Notes` varchar(255),
	`Status` varchar(255) DEFAULT 'Scheduled',
	`AppointmentType` varchar(255),
	`Duration` int,
	`ReminderSent` bit(1),
	`FollowUpNeeded` bit(1),
	`PatientFeedback` varchar(255),
	PRIMARY KEY (`id`)
);

CREATE TABLE IF NOT EXISTS `Cabinet` (
	`CabinetNumber` varchar(255) NOT NULL,
	`LastInspectionDate` date,
	`NextInspectionDate` date,
	`Location` varchar(255),
	`IsEmergencyCabinet` bit(1),
	`id` int NOT NULL,
	`Capacity` int,
	`Equipment` varchar(255),
	`IsActive` bit(1),
	`Notes` varchar(255),
	`Type` varchar(255),
	`Floor` int,
	`Building` varchar(255),
	`ContactNumber` varchar(255)
);

CREATE TABLE IF NOT EXISTS `TreatmentPlan` (
	`id` int NOT NULL,
	`ProcedurName` varchar(255) NOT NULL,
	`Description` varchar(255),
	`PatientId` int,
	`DoctorId` int,
	`Status` varchar(255) NOT NULL,
	`Cost` decimal(18,2),
	`Duration` int,
	`StartDate` date,
	`EndDate` date,
	`Frequency` varchar(255),
	`Notes` varchar(255),
	`IsActive` bit(1),
	`FollowUpRequired` bit(1),
	PRIMARY KEY (`id`)
);

CREATE TABLE IF NOT EXISTS `Analyses` (
	`id` int NOT NULL,
	`AnalyseName` varchar(255) NOT NULL,
	`Results` varchar(255),
	`IsDone` bit(1) NOT NULL,
	`DatePerformed` date,
	`PerformedBy` int,
	`PatientId` int,
	`Remarks` varchar(255),
	`IsActive` bit(1),
	`SampleType` varchar(255),
	`LabTechnician` varchar(255),
	`TestLocation` varchar(255),
	`TestCost` decimal(18,2),
	PRIMARY KEY (`id`)
);

CREATE TABLE IF NOT EXISTS `User` (
	`id` int NOT NULL,
	`FirstName` varchar(255) NOT NULL,
	`LastName` varchar(255),
	`Patronimic` varchar(255),
	`Email` varchar(255),
	`PasswordHash` varchar(255),
	`PhoneNumber` varchar(255),
	`DateOfBirth` date,
	`Role` varchar(255) NOT NULL,
	`CreatedAt` datetime,
	`IsActive` bit(1),
	`Address` varchar(255),
	`ProfilePicture` varchar(255),
	`LastLogin` datetime,
	PRIMARY KEY (`id`)
);

CREATE TABLE IF NOT EXISTS `Patient` (
	`id` int NOT NULL,
	`UserId` int NOT NULL,
	`MedicalHistory` varchar(255),
	`Allergies` varchar(255),
	`InsuranceNumber` varchar(255),
	`EmergencyContact` varchar(255),
	`DateOfRegistration` date,
	`Gender` varchar(255),
	`IsActive` bit(1),
	`Height` decimal(5,2),
	`Weight` decimal(5,2),
	`BloodType` varchar(255),
	`Ethnicity` varchar(255),
	PRIMARY KEY (`id`)
);

CREATE TABLE IF NOT EXISTS `Doctor` (
	`LicenseNumber` varchar(255),
	`id` int NOT NULL,
	`Speciality` varchar(255) NOT NULL,
	`YearsOfExperience` int,
	`ConsultationFee` decimal(18,2),
	`OfficeHours` varchar(255),
	`PhoneNumber` varchar(255),
	`IsActive` bit(1),
	`ProfilePicture` varchar(255),
	`Education` varchar(255),
	`Certifications` varchar(255),
	`UserId` int NOT NULL,
	`LanguagesSpoken` varchar(255),
	PRIMARY KEY (`id`)
);

CREATE TABLE IF NOT EXISTS `Diagnos` (
	`id` int NOT NULL,
	`Name` varchar(255) NOT NULL,
	`Description` varchar(255),
	`TreatmentPlanId` int,
	`Severity` varchar(255),
	`PatientId` int,
	`DoctorId` int,
	`IsActive` bit(1) DEFAULT '1',
	`DateDiagnosed` date,
	`FollowUpDate` date,
	`Notes` varchar(255),
	`IsChronic` bit(1),
	`RelatedConditions` varchar(255),
	PRIMARY KEY (`id`)
);

CREATE TABLE IF NOT EXISTS `HillHistory` (
	`UpdatedAt` datetime,
	`id` int NOT NULL,
	`PatientId` int NOT NULL,
	`DiagnosId` int,
	`AnalysesId` int,
	`DateRecorded` date,
	`Notes` varchar(255),
	`IsActive` bit(1),
	`RecordedBy` int,
	`Symptoms` varchar(255),
	`TreatmentGiven` varchar(255),
	`FollowUpDate` date,
	`NextAppointment` date,
	`IsEmergency` bit(1),
	`Location` varchar(255),
	PRIMARY KEY (`id`)
);

ALTER TABLE `Appointment` ADD CONSTRAINT `Appointment_fk1` FOREIGN KEY (`PatientId`) REFERENCES `Patient`(`id`);

ALTER TABLE `Appointment` ADD CONSTRAINT `Appointment_fk2` FOREIGN KEY (`DoctorId`) REFERENCES `Doctor`(`id`);

ALTER TABLE `Appointment` ADD CONSTRAINT `Appointment_fk4` FOREIGN KEY (`CabinetId`) REFERENCES `Cabinet`(`id`);

ALTER TABLE `TreatmentPlan` ADD CONSTRAINT `TreatmentPlan_fk3` FOREIGN KEY (`PatientId`) REFERENCES `Patient`(`id`);

ALTER TABLE `TreatmentPlan` ADD CONSTRAINT `TreatmentPlan_fk4` FOREIGN KEY (`DoctorId`) REFERENCES `Doctor`(`id`);
ALTER TABLE `Analyses` ADD CONSTRAINT `Analyses_fk5` FOREIGN KEY (`PerformedBy`) REFERENCES `Doctor`(`id`);

ALTER TABLE `Analyses` ADD CONSTRAINT `Analyses_fk6` FOREIGN KEY (`PatientId`) REFERENCES `Patient`(`id`);

ALTER TABLE `Patient` ADD CONSTRAINT `Patient_fk1` FOREIGN KEY (`UserId`) REFERENCES `User`(`id`);
ALTER TABLE `Doctor` ADD CONSTRAINT `Doctor_fk11` FOREIGN KEY (`UserId`) REFERENCES `User`(`id`);
ALTER TABLE `Diagnos` ADD CONSTRAINT `Diagnos_fk3` FOREIGN KEY (`TreatmentPlanId`) REFERENCES `TreatmentPlan`(`id`);

ALTER TABLE `Diagnos` ADD CONSTRAINT `Diagnos_fk5` FOREIGN KEY (`PatientId`) REFERENCES `Patient`(`id`);

ALTER TABLE `Diagnos` ADD CONSTRAINT `Diagnos_fk6` FOREIGN KEY (`DoctorId`) REFERENCES `Doctor`(`id`);
ALTER TABLE `HillHistory` ADD CONSTRAINT `HillHistory_fk2` FOREIGN KEY (`PatientId`) REFERENCES `Patient`(`id`);

ALTER TABLE `HillHistory` ADD CONSTRAINT `HillHistory_fk3` FOREIGN KEY (`DiagnosId`) REFERENCES `Diagnos`(`id`);

ALTER TABLE `HillHistory` ADD CONSTRAINT `HillHistory_fk4` FOREIGN KEY (`AnalysesId`) REFERENCES `Analyses`(`id`);