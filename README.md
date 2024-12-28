# Архитектура ПО
## Урок 6. Принципы построения приложений «чистая архитектура»

На семинаре с преподавателем проектируется UML диаграмма классов приложения для медицинского центра. Пример диаграммы приведен ниже:

**Задание** 

Разработать полную ERD домена в https://www.dbdesigner.net/.

![](src/001.jpg)

Сервис записи на прием к врачу-специалисту предназначен для управления процессом взаимодействия между пациентами и медицинскими учреждениями. Он позволяет пользователям записываться на прием к врачам, отслеживать медицинскую историю и планировать лечение. 

### Основные компоненты сервиса:

1. Пользователи (User):
   - Каждый пользователь, включая пациентов и врачей, имеет уникальный идентификатор и базовые данные, такие как имя, фамилия, отчество, электронная почта, номер телефона и дата рождения. 
   - В поле "Role" указывается, является ли пользователь пациентом или врачом.

2. Пациенты (Patient):
   - Каждый пациент связан с учетной записью пользователя и имеет уникальный идентификатор.
   - В их профиле хранится информация о медицинской истории, аллергиях, страховке и экстренных контактах.
   - Дата регистрации позволяет отслеживать, когда пациент зарегистрировался в системе.

3. Врачи (Doctor):
   - Врачи также имеют уникальные идентификаторы и связаны с учетными записями пользователей.
   - Для каждого врача хранятся данные о специальности, лицензии, опыте работы и размере консультационного вознаграждения.
   - Информация об их рабочем времени позволяет пациентам планировать приемы.

4. Анализы (Analyses):
   - Запись о каждом анализе включает уникальный идентификатор, название анализа, результаты, статус выполнения и информацию о том, кто его выполнил.
   - Это позволяет отслеживать медицинские процедуры, проведенные для пациента.

5. Диагнозы (Diagnos):
   - Хранятся данные о диагнозах пациентов, включая описание, план лечения и врачей, установивших диагноз.
   - Поле "Severity" позволяет оценивать степень проблемы, что может быть полезно для определения приоритетов в лечении.

6. Планы лечения (TreatmentPlan):
   - Каждый план лечения связан с пациентами и врачами и включает описание лечения, статус, стоимость и длительность.
   - Это помогает систематизировать и упорядочить уход за пациентами.

7. История болезней (HillHistory):
   - Ведение истории болезней позволяет медицинскому персоналу отслеживать состояние пациента, включая его диагнозы и проведенные анализы.
   - Данные о нотах и записях помогают поддерживать актуальность информации о состоянии здоровья пациента.

8. Записи на прием (Appointment):
   - Каждая запись включает информацию о пациенте, враче, времени приема, кабинете и статусе (например, отменено или запланировано).
   - Этот компонент жизненно важен для координации приемов и управления расписанием врачей.

9. Кабинеты (Cabinet):
   - Информация о кабинетах, где назначаются приемы, включая номер кабинета, местоположение и оснащение, помогает пациентам знать, где они должны явиться.

### Функции сервиса:

— Запись на прием: Пациенты могут просматривать расписания врачей, выбирать удобное время и записываться на прием.
— Управление медицинскими данными: Врачи могут добавлять и обновлять медицинские записи, анализы и диагнозы, а также отслеживать лечение и прогресс своих пациентов.
— Уведомления и напоминания: Данная функция позволяет пользователям быть в курсе предстоящих приемов и важных событий, связанных с их здоровьем.
— История взаимодействий: Все взаимодействия (приемы, анализы, диагнозы) автоматически сохраняются в базе данных, обеспечивая мгновенный доступ к истории болезни.

Таким образом, сервис записи на прием к врачу-специалисту предоставляет эффективное решение для управления медицинскими приемами, облегчая взаимодействие между пациентами и врачами, а также улучшая качество обслуживания в медицинских учреждениях.


CREATE TABLE [User] (
    [id] INT NOT NULL PRIMARY KEY,
    [FirstName] NVARCHAR(50) NOT NULL,
    [LastName] NVARCHAR(50),
    [Patronimic] NVARCHAR(50),
    [Email] NVARCHAR(100),
    [PasswordHash] NVARCHAR(255),
    [PhoneNumber] NVARCHAR(15),
    [DateOfBirth] DATE,
    [Role] NVARCHAR(20) NOT NULL,
    [CreatedAt] DATETIME DEFAULT GETDATE()
);

CREATE TABLE [Patient] (
    [id] INT NOT NULL PRIMARY KEY,
    [UserId] INT NOT NULL UNIQUE,
    [MedicalHistory] NVARCHAR(MAX),
    [Allergies] NVARCHAR(MAX),
    [InsuranceNumber] NVARCHAR(50),
    [EmergencyContact] NVARCHAR(100),
    [DateOfRegistration] DATE DEFAULT GETDATE(),
    [Gender] NVARCHAR(10),
    FOREIGN KEY ([UserId]) REFERENCES [User]([id]) ON DELETE CASCADE
);

CREATE TABLE [Doctor] (
    [id] INT NOT NULL PRIMARY KEY,
    [UserId] INT NOT NULL UNIQUE,
    [Speciality] NVARCHAR(100) NOT NULL,
    [LicenseNumber] NVARCHAR(50),
    [YearsOfExperience] INT,
    [ConsultationFee] DECIMAL(18,2),
    [OfficeHours] NVARCHAR(50),
    [PhoneNumber] NVARCHAR(15),
    FOREIGN KEY ([UserId]) REFERENCES [User]([id]) ON DELETE CASCADE
);

CREATE TABLE [Analyses] (
    [id] INT NOT NULL PRIMARY KEY,
    [AnalyseName] NVARCHAR(100) NOT NULL,
    [Results] NVARCHAR(MAX),
    [IsDone] BIT NOT NULL,
    [DatePerformed] DATE DEFAULT GETDATE(),
    [PerformedBy] INT,
    [PatientId] INT,
    [Remarks] NVARCHAR(MAX),
    FOREIGN KEY ([PerformedBy]) REFERENCES [Doctor]([id]),
    FOREIGN KEY ([PatientId]) REFERENCES [Patient]([id])
);

CREATE TABLE [Diagnos] (
    [id] INT NOT NULL PRIMARY KEY,
    [Name] NVARCHAR(100) NOT NULL,
    [Description] NVARCHAR(MAX),
    [TreatmentPlanId] INT,
    [Severity] NVARCHAR(20),
    [PatientId] INT,
    [DoctorId] INT,
    [IsActive] BIT DEFAULT 1,
    FOREIGN KEY ([TreatmentPlanId]) REFERENCES [TreatmentPlan]([id]),
    FOREIGN KEY ([PatientId]) REFERENCES [Patient]([id]),
    FOREIGN KEY ([DoctorId]) REFERENCES [Doctor]([id])
);

CREATE TABLE [TreatmentPlan] (
    [id] INT NOT NULL PRIMARY KEY,
    [ProcedurName] NVARCHAR(100) NOT NULL,
    [Description] NVARCHAR(MAX),
    [PatientId] INT,
    [DoctorId] INT,
    [Status] NVARCHAR(20) NOT NULL,
    [Cost] DECIMAL(18,2),
    [Duration] INT,
    FOREIGN KEY ([PatientId]) REFERENCES [Patient]([id]),
    FOREIGN KEY ([DoctorId]) REFERENCES [Doctor]([id])
);

CREATE TABLE [HillHistory] (
    [id] INT NOT NULL PRIMARY KEY,
    [PatientId] INT NOT NULL,
    [DiagnosId] INT,
    [AnalysesId] INT,
    [DateRecorded] DATE DEFAULT GETDATE(),
    [Notes] NVARCHAR(MAX),
    [IsActive] BIT DEFAULT 1,
    [RecordedBy] INT,
    FOREIGN KEY ([PatientId]) REFERENCES [Patient]([id]),
    FOREIGN KEY ([DiagnosId]) REFERENCES [Diagnos]([id]),
    FOREIGN KEY ([AnalysesId]) REFERENCES [Analyses]([id])
);

CREATE TABLE [Appointment] (
    [id] INT NOT NULL PRIMARY KEY,
    [PatientId] INT NOT NULL,
    [DoctorId] INT NOT NULL,
    [TimeOfReceipt] DATETIME NOT NULL,
    [CabinetId] INT,
    [IsCancelled] BIT DEFAULT 0,
    [Notes] NVARCHAR(MAX),
    [Status] NVARCHAR(20) DEFAULT 'Scheduled',
    FOREIGN KEY ([PatientId]) REFERENCES [Patient]([id]),
    FOREIGN KEY ([DoctorId]) REFERENCES [Doctor]([id]),
    FOREIGN KEY ([CabinetId]) REFERENCES [Cabinet]([id])
);

CREATE TABLE [Cabinet] (
    [id] INT NOT NULL PRIMARY KEY,
    [CabinetNumber] NVARCHAR(10) NOT NULL,
    [Location] NVARCHAR(100),
    [Capacity] INT,
    [Equipment] NVARCHAR(MAX),
    [IsActive] BIT DEFAULT 1,
    [Notes] NVARCHAR(MAX),
    [Type] NVARCHAR(50)
);
