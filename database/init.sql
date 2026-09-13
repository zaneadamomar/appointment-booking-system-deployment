USE [AppointmentBookings];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

/* ============================================================
   TABLES
   ============================================================ */

CREATE TABLE dbo.Status
(
    StatusId INT IDENTITY(1,1) NOT NULL,
    Status NVARCHAR(50) NOT NULL,

    CONSTRAINT PK_Status
        PRIMARY KEY CLUSTERED (StatusId)
);
GO


CREATE TABLE dbo.Branches
(
    BranchId UNIQUEIDENTIFIER NOT NULL
        CONSTRAINT DF_Branches_BranchId DEFAULT NEWSEQUENTIALID(),

    BranchName NVARCHAR(200) NOT NULL,
    AddressLine1 NVARCHAR(200) NULL,
    AddressLine2 NVARCHAR(200) NULL,
    City NVARCHAR(100) NULL,
    PostalCode NVARCHAR(20) NULL,

    IsActive BIT NOT NULL
        CONSTRAINT DF_Branches_IsActive DEFAULT (1),

    CreatedDate DATETIME2(0) NOT NULL
        CONSTRAINT DF_Branches_CreatedDate DEFAULT SYSUTCDATETIME(),

    CONSTRAINT PK_Branches
        PRIMARY KEY CLUSTERED (BranchId)
);
GO


CREATE TABLE dbo.Services
(
    ServiceId UNIQUEIDENTIFIER NOT NULL
        CONSTRAINT DF_Services_ServiceId DEFAULT NEWSEQUENTIALID(),

    ServiceName NVARCHAR(200) NOT NULL,
    Description NVARCHAR(1000) NULL,
    DurationMinutes INT NOT NULL,

    IsActive BIT NOT NULL
        CONSTRAINT DF_Services_IsActive DEFAULT (1),

    CreatedDate DATETIME2(0) NOT NULL
        CONSTRAINT DF_Services_CreatedDate DEFAULT SYSUTCDATETIME(),

    CONSTRAINT PK_Services
        PRIMARY KEY CLUSTERED (ServiceId),

    CONSTRAINT CK_Services_Duration
        CHECK (DurationMinutes > 0)
);
GO


CREATE TABLE dbo.Users
(
    UserId UNIQUEIDENTIFIER NOT NULL
        CONSTRAINT DF_Users_UserId DEFAULT NEWSEQUENTIALID(),

    FirstName NVARCHAR(100) NOT NULL,
    LastName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(255) NULL,

    IsActive BIT NOT NULL
        CONSTRAINT DF_Users_IsActive DEFAULT (1),

    CreatedDate DATETIME2(0) NOT NULL
        CONSTRAINT DF_Users_CreatedDate DEFAULT SYSUTCDATETIME(),

    CONSTRAINT PK_Users
        PRIMARY KEY CLUSTERED (UserId)
);
GO


CREATE TABLE dbo.Bookings
(
    BookingId UNIQUEIDENTIFIER NOT NULL
        CONSTRAINT DF_Bookings_BookingId DEFAULT NEWSEQUENTIALID(),

    UserId UNIQUEIDENTIFIER NOT NULL,
    BranchId UNIQUEIDENTIFIER NOT NULL,
    ServiceId UNIQUEIDENTIFIER NOT NULL,

    BookingDate DATE NOT NULL,
    StartTime TIME(0) NOT NULL,
    EndTime TIME(0) NOT NULL,

    StatusId INT NOT NULL,

    CreatedDate DATETIME2(0) NOT NULL
        CONSTRAINT DF_Bookings_CreatedDate DEFAULT SYSUTCDATETIME(),

    UpdatedDate DATETIME2(0) NULL
        CONSTRAINT DF_Bookings_UpdatedDate DEFAULT GETDATE(),

    CONSTRAINT PK_Bookings
        PRIMARY KEY CLUSTERED (BookingId),

    CONSTRAINT CK_Bookings_Time
        CHECK (EndTime > StartTime)
);
GO


/* ============================================================
   SEED STATUS
   ============================================================ */

SET IDENTITY_INSERT dbo.Status ON;
GO

INSERT INTO dbo.Status
(
    StatusId,
    Status
)
VALUES
    (1, N'Confirmed'),
    (2, N'Completed'),
    (3, N'Cancelled');
GO

SET IDENTITY_INSERT dbo.Status OFF;
GO


/* ============================================================
   SEED BRANCHES
   ============================================================ */

INSERT INTO dbo.Branches
(
    BranchId,
    BranchName,
    AddressLine1,
    AddressLine2,
    City,
    PostalCode,
    IsActive
)
VALUES
(
    '2609ce21-42a8-f111-8451-80afca0982d6',
    N'Downtown Branch',
    N'123 Financial District Avenue',
    N'Umhlanga',
    N'Durban',
    N'4125',
    1
),
(
    'f95b2d48-42a8-f111-8451-80afca0982d6',
    N'Northside Hub',
    N'8850 Techno Park Drive',
    N'Phoenix',
    N'Durban',
    N'4729',
    1
),
(
    '67880958-42a8-f111-8451-80afca0982d6',
    N'Westside Plaza',
    N'400 Commerce Blvd',
    N'Bluff',
    N'Durban',
    N'4052',
    1
),
(
    '21df8877-42a8-f111-8451-80afca0982d6',
    N'East Valley Retail',
    N'210 Valley Road',
    N'CBD',
    N'Durban',
    N'1258',
    1
);
GO


/* ============================================================
   SEED SERVICES
   ============================================================ */

INSERT INTO dbo.Services
(
    ServiceId,
    ServiceName,
    Description,
    DurationMinutes,
    IsActive
)
VALUES
(
    '355b868a-41a8-f111-8451-80afca0982d6',
    N'General Enquiry',
    N'Have a quick question or need basic account assistance? Our representatives are here to help.',
    15,
    1
),
(
    'ac77929c-41a8-f111-8451-80afca0982d6',
    N'Financial Planning',
    N'Get personalised guidance and financial planning assistance.',
    30,
    1
),
(
    'c978dbab-41a8-f111-8451-80afca0982d6',
    N'Mortgage Services',
    N'Discuss mortgage options, applications and related services.',
    45,
    1
),
(
    '87d244b6-41a8-f111-8451-80afca0982d6',
    N'Account Management',
    N'Get assistance with account-related requests and management.',
    60,
    1
);
GO


/* ============================================================
   SEED USERS
   ============================================================ */

INSERT INTO dbo.Users
(
    UserId,
    FirstName,
    LastName,
    Email,
    IsActive
)
VALUES
(
    'b912fda9-40a8-f111-8451-80afca0982d6',
    N'John',
    N'Doe',
    N'JohnDoe@outlook.com',
    1
),
(
    'e67458b0-40a8-f111-8451-80afca0982d6',
    N'Jane',
    N'Doe',
    N'JaneDoe@outlook.com',
    1
),
(
    '4a4398d0-40a8-f111-8451-80afca0982d6',
    N'Alex',
    N'Green',
    N'AlexGreen@outlook.com',
    1
),
(
    '94dfd802-41a8-f111-8451-80afca0982d6',
    N'Joshua',
    N'Jones',
    N'Joshuajones@outlook.com',
    1
),
(
    '80db9c10-41a8-f111-8451-80afca0982d6',
    N'lucas',
    N'Pixel',
    N'Lucaspixel@outlook.com',
    1
);
GO


/* ============================================================
   FOREIGN KEYS
   ============================================================ */

ALTER TABLE dbo.Bookings
ADD CONSTRAINT FK_Bookings_Users
    FOREIGN KEY (UserId)
    REFERENCES dbo.Users(UserId);
GO

ALTER TABLE dbo.Bookings
ADD CONSTRAINT FK_Bookings_Branches
    FOREIGN KEY (BranchId)
    REFERENCES dbo.Branches(BranchId);
GO

ALTER TABLE dbo.Bookings
ADD CONSTRAINT FK_Bookings_Services
    FOREIGN KEY (ServiceId)
    REFERENCES dbo.Services(ServiceId);
GO

ALTER TABLE dbo.Bookings
ADD CONSTRAINT FK_Bookings_Status
    FOREIGN KEY (StatusId)
    REFERENCES dbo.Status(StatusId);
GO


/* ============================================================
   EXISTING TEST BOOKINGS
   ============================================================ */

INSERT INTO dbo.Bookings
(
    BookingId,
    UserId,
    BranchId,
    ServiceId,
    BookingDate,
    StartTime,
    EndTime,
    StatusId
)
VALUES
(
    'afd64236-0000-0000-0000-000000000001',
    'b912fda9-40a8-f111-8451-80afca0982d6',
    'f95b2d48-42a8-f111-8451-80afca0982d6',
    'c978dbab-41a8-f111-8451-80afca0982d6',
    '2026-09-14',
    '13:00',
    '13:45',
    1
),
(
    '1a2f3b5c-0000-0000-0000-000000000002',
    '4a4398d0-40a8-f111-8451-80afca0982d6',
    '67880958-42a8-f111-8451-80afca0982d6',
    'ac77929c-41a8-f111-8451-80afca0982d6',
    '2026-09-09',
    '13:00',
    '13:30',
    1
),
(
    '0ec82753-0000-0000-0000-000000000003',
    '4a4398d0-40a8-f111-8451-80afca0982d6',
    '2609ce21-42a8-f111-8451-80afca0982d6',
    'ac77929c-41a8-f111-8451-80afca0982d6',
    '2026-09-07',
    '10:00',
    '10:30',
    2
),
(
    'c20d5d79-0000-0000-0000-000000000004',
    'b912fda9-40a8-f111-8451-80afca0982d6',
    'f95b2d48-42a8-f111-8451-80afca0982d6',
    'c978dbab-41a8-f111-8451-80afca0982d6',
    '2026-09-07',
    '15:30',
    '16:15',
    1
),
(
    '999b1a7a-0000-0000-0000-000000000005',
    'b912fda9-40a8-f111-8451-80afca0982d6',
    '2609ce21-42a8-f111-8451-80afca0982d6',
    '87d244b6-41a8-f111-8451-80afca0982d6',
    '2026-09-07',
    '13:00',
    '14:00',
    3
),
(
    'd6596290-0000-0000-0000-000000000006',
    '94dfd802-41a8-f111-8451-80afca0982d6',
    '67880958-42a8-f111-8451-80afca0982d6',
    '355b868a-41a8-f111-8451-80afca0982d6',
    '2026-09-09',
    '10:00',
    '10:15',
    1
),
(
    '12fc946a-0000-0000-0000-000000000007',
    'e67458b0-40a8-f111-8451-80afca0982d6',
    '67880958-42a8-f111-8451-80afca0982d6',
    'c978dbab-41a8-f111-8451-80afca0982d6',
    '2026-09-09',
    '10:00',
    '10:45',
    3
),
(
    '4717176d-0000-0000-0000-000000000008',
    'b912fda9-40a8-f111-8451-80afca0982d6',
    '2609ce21-42a8-f111-8451-80afca0982d6',
    '355b868a-41a8-f111-8451-80afca0982d6',
    '2026-09-10',
    '10:30',
    '10:45',
    2
),
(
    '3f18a2fb-0000-0000-0000-000000000009',
    'b912fda9-40a8-f111-8451-80afca0982d6',
    '2609ce21-42a8-f111-8451-80afca0982d6',
    '355b868a-41a8-f111-8451-80afca0982d6',
    '2026-09-07',
    '12:45',
    '13:00',
    3
);
GO


/* ============================================================
   GET USERS
   ============================================================ */

CREATE OR ALTER PROCEDURE dbo.GetUsers
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        UserId,
        FirstName,
        LastName,
        Email,
        IsActive,
        CreatedDate
    FROM dbo.Users
    WHERE IsActive = 1
    ORDER BY FirstName, LastName;
END;
GO


/* ============================================================
   GET BRANCHES
   ============================================================ */

CREATE OR ALTER PROCEDURE dbo.GetBranches
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        BranchId,
        BranchName,
        AddressLine1,
        AddressLine2,
        City,
        PostalCode,
        IsActive,
        CreatedDate
    FROM dbo.Branches
    WHERE IsActive = 1
    ORDER BY BranchName;
END;
GO


/* ============================================================
   GET SERVICES
   ============================================================ */

CREATE OR ALTER PROCEDURE dbo.GetServices
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        ServiceId,
        ServiceName,
        Description,
        DurationMinutes,
        IsActive,
        CreatedDate
    FROM dbo.Services
    WHERE IsActive = 1
    ORDER BY DurationMinutes, ServiceName;
END;
GO


/* ============================================================
   GET AVAILABLE TIME SLOTS
   ============================================================ */

CREATE OR ALTER PROCEDURE dbo.GetAvailableTimeSlots
(
    @BranchId UNIQUEIDENTIFIER,
    @ServiceId UNIQUEIDENTIFIER,
    @BookingDate DATE,
    @OpenTime TIME(0) = '09:00',
    @CloseTime TIME(0) = '17:00',
    @SlotMinutes INT = 15
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @DurationMinutes INT;

    SELECT @DurationMinutes = DurationMinutes
    FROM dbo.Services
    WHERE ServiceId = @ServiceId
      AND IsActive = 1;

    IF @DurationMinutes IS NULL
    BEGIN
        RAISERROR('Service not found or inactive.', 16, 1);
        RETURN;
    END;

    ;WITH TimeSlots AS
    (
        SELECT
            @OpenTime AS StartTime

        UNION ALL

        SELECT
            CAST(
                DATEADD(
                    MINUTE,
                    @SlotMinutes,
                    CAST(StartTime AS DATETIME)
                ) AS TIME(0)
            )
        FROM TimeSlots
        WHERE DATEADD(
                MINUTE,
                @SlotMinutes,
                CAST(StartTime AS DATETIME)
              )
              <
              DATEADD(
                MINUTE,
                -@DurationMinutes,
                CAST(@CloseTime AS DATETIME)
              )
    )
    SELECT
        StartTime,
        CAST(
            DATEADD(
                MINUTE,
                @DurationMinutes,
                CAST(StartTime AS DATETIME)
            ) AS TIME(0)
        ) AS EndTime,

        CAST(
            CASE
                WHEN EXISTS
                (
                    SELECT 1
                    FROM dbo.Bookings b
                    WHERE b.BranchId = @BranchId
                      AND b.BookingDate = @BookingDate
                      AND b.StatusId <> 3
                      AND
                      (
                          b.StartTime <
                          CAST(
                              DATEADD(
                                  MINUTE,
                                  @DurationMinutes,
                                  CAST(StartTime AS DATETIME)
                              ) AS TIME(0)
                          )
                          AND
                          b.EndTime > StartTime
                      )
                )
                THEN 0
                ELSE 1
            END
            AS BIT
        ) AS IsAvailable

    FROM TimeSlots

    WHERE
        @BookingDate > CAST(GETDATE() AS DATE)
        OR
        (
            @BookingDate = CAST(GETDATE() AS DATE)
            AND StartTime > CAST(GETDATE() AS TIME(0))
        )

    ORDER BY StartTime

    OPTION (MAXRECURSION 200);
END;
GO


/* ============================================================
   CREATE BOOKING
   ============================================================ */

CREATE OR ALTER PROCEDURE dbo.CreateBooking
(
    @UserId UNIQUEIDENTIFIER,
    @BranchId UNIQUEIDENTIFIER,
    @ServiceId UNIQUEIDENTIFIER,
    @BookingDate DATE,
    @StartTime TIME(0)
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE
        @DurationMinutes INT,
        @EndTime TIME(0),
        @ResultCode INT = 0,
        @ResultMessage NVARCHAR(500),
        @BookingId UNIQUEIDENTIFIER;

    /* Service validation */
    SELECT @DurationMinutes = DurationMinutes
    FROM dbo.Services
    WHERE ServiceId = @ServiceId
      AND IsActive = 1;

    IF @DurationMinutes IS NULL
    BEGIN
        SELECT
            NULL AS BookingId,
            N'Service not found or inactive.' AS ResultMessage,
            3 AS ResultCode;
        RETURN;
    END;

    /* Branch validation */
    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.Branches
        WHERE BranchId = @BranchId
          AND IsActive = 1
    )
    BEGIN
        SELECT
            NULL AS BookingId,
            N'Branch not found or inactive.' AS ResultMessage,
            4 AS ResultCode;
        RETURN;
    END;

    /* User validation */
    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.Users
        WHERE UserId = @UserId
          AND IsActive = 1
    )
    BEGIN
        SELECT
            NULL AS BookingId,
            N'User not found or inactive.' AS ResultMessage,
            5 AS ResultCode;
        RETURN;
    END;

    /* Calculate end time */
    SET @EndTime =
        CAST(
            DATEADD(
                MINUTE,
                @DurationMinutes,
                CAST(@StartTime AS DATETIME)
            ) AS TIME(0)
        );

    /* Past date/time */
    IF
    (
        @BookingDate < CAST(GETDATE() AS DATE)
        OR
        (
            @BookingDate = CAST(GETDATE() AS DATE)
            AND @StartTime <= CAST(GETDATE() AS TIME(0))
        )
    )
    BEGIN
        SELECT
            NULL AS BookingId,
            N'Booking date/time is in the past.' AS ResultMessage,
            6 AS ResultCode;
        RETURN;
    END;

    /* Business hours */
    IF
        @StartTime < '09:00'
        OR @EndTime > '17:00'
    BEGIN
        SELECT
            NULL AS BookingId,
            N'Booking time is outside business hours.' AS ResultMessage,
            7 AS ResultCode;
        RETURN;
    END;

    BEGIN TRANSACTION;

    /* Branch overlap */
    IF EXISTS
    (
        SELECT 1
        FROM dbo.Bookings WITH (UPDLOCK, HOLDLOCK)
        WHERE BranchId = @BranchId
          AND BookingDate = @BookingDate
          AND StatusId <> 3
          AND StartTime < @EndTime
          AND EndTime > @StartTime
    )
    BEGIN
        ROLLBACK TRANSACTION;

        SELECT
            NULL AS BookingId,
            N'The selected time is already booked at this branch.' AS ResultMessage,
            1 AS ResultCode;
        RETURN;
    END;

    /* User overlap */
    IF EXISTS
    (
        SELECT 1
        FROM dbo.Bookings WITH (UPDLOCK, HOLDLOCK)
        WHERE UserId = @UserId
          AND BookingDate = @BookingDate
          AND StatusId <> 3
          AND StartTime < @EndTime
          AND EndTime > @StartTime
    )
    BEGIN
        ROLLBACK TRANSACTION;

        SELECT
            NULL AS BookingId,
            N'The user already has a booking at this time.' AS ResultMessage,
            2 AS ResultCode;
        RETURN;
    END;

    /* Create booking */
    SET @BookingId = NEWID();

    INSERT INTO dbo.Bookings
    (
        BookingId,
        UserId,
        BranchId,
        ServiceId,
        BookingDate,
        StartTime,
        EndTime,
        StatusId,
        CreatedDate
    )
    VALUES
    (
        @BookingId,
        @UserId,
        @BranchId,
        @ServiceId,
        @BookingDate,
        @StartTime,
        @EndTime,
        1,
        SYSUTCDATETIME()
    );

    COMMIT TRANSACTION;

    SELECT
        @BookingId AS BookingId,
        N'Booking created successfully.' AS ResultMessage,
        0 AS ResultCode;
END;
GO


/* ============================================================
   GET BOOKINGS
   ============================================================ */

CREATE OR ALTER PROCEDURE dbo.GetBookings
(
    @BranchId UNIQUEIDENTIFIER = NULL,
    @UserId UNIQUEIDENTIFIER = NULL,
    @FromDate DATE = NULL,
    @ToDate DATE = NULL,
    @StatusId INT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        b.BookingId,
        b.UserId,
        u.FirstName,
        u.LastName,
        u.Email,

        b.BranchId,
        br.BranchName,

        b.ServiceId,
        s.ServiceName,
        s.DurationMinutes,

        b.BookingDate,
        b.StartTime,
        b.EndTime,

        b.StatusId,
        st.Status,

        b.CreatedDate,
        b.UpdatedDate

    FROM dbo.Bookings b

    INNER JOIN dbo.Users u
        ON u.UserId = b.UserId

    INNER JOIN dbo.Branches br
        ON br.BranchId = b.BranchId

    INNER JOIN dbo.Services s
        ON s.ServiceId = b.ServiceId

    INNER JOIN dbo.Status st
        ON st.StatusId = b.StatusId

    WHERE
        (@BranchId IS NULL OR b.BranchId = @BranchId)
        AND
        (@UserId IS NULL OR b.UserId = @UserId)
        AND
        (@FromDate IS NULL OR b.BookingDate >= @FromDate)
        AND
        (@ToDate IS NULL OR b.BookingDate <= @ToDate)
        AND
        (@StatusId IS NULL OR b.StatusId = @StatusId)

    ORDER BY
        b.BookingDate,
        b.StartTime;
END;
GO


/* ============================================================
   CANCEL BOOKING
   ============================================================ */

CREATE OR ALTER PROCEDURE dbo.CancelBooking
(
    @BookingId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.Bookings
        WHERE BookingId = @BookingId
          AND (@UserId IS NULL OR UserId = @UserId)
    )
    BEGIN
        SELECT
            1 AS ResultCode,
            N'Booking not found or does not belong to the user.' AS ResultMessage;
        RETURN;
    END;

    UPDATE dbo.Bookings
    SET
        StatusId = 3,
        UpdatedDate = GETDATE()
    WHERE BookingId = @BookingId;

    SELECT
        0 AS ResultCode,
        N'Booking cancelled successfully.' AS ResultMessage;
END;
GO


/* ============================================================
   UPDATE BOOKING STATUS
   ============================================================ */

CREATE OR ALTER PROCEDURE dbo.UpdateBookingStatus
(
    @BookingId UNIQUEIDENTIFIER,
    @StatusId INT
)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.Bookings
        WHERE BookingId = @BookingId
    )
    BEGIN
        SELECT
            1 AS ResultCode,
            N'Booking not found.' AS ResultMessage;
        RETURN;
    END;

    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.Status
        WHERE StatusId = @StatusId
    )
    BEGIN
        SELECT
            2 AS ResultCode,
            N'Invalid status.' AS ResultMessage;
        RETURN;
    END;

    UPDATE dbo.Bookings
    SET
        StatusId = @StatusId,
        UpdatedDate = GETDATE()
    WHERE BookingId = @BookingId;

    SELECT
        0 AS ResultCode,
        N'Booking status updated successfully.' AS ResultMessage;
END;
GO


/* ============================================================
   RESCHEDULE BOOKING
   ============================================================ */

CREATE OR ALTER PROCEDURE dbo.RescheduleBooking
(
    @BookingId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @BookingDate DATE,
    @StartTime TIME(0)
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE
        @BranchId UNIQUEIDENTIFIER,
        @ServiceId UNIQUEIDENTIFIER,
        @DurationMinutes INT,
        @EndTime TIME(0);

    SELECT
        @BranchId = BranchId,
        @ServiceId = ServiceId
    FROM dbo.Bookings
    WHERE BookingId = @BookingId
      AND UserId = @UserId
      AND StatusId <> 3;

    IF @BranchId IS NULL
    BEGIN
        SELECT
            1 AS ResultCode,
            N'Booking not found or cannot be rescheduled.' AS ResultMessage;
        RETURN;
    END;

    SELECT
        @DurationMinutes = DurationMinutes
    FROM dbo.Services
    WHERE ServiceId = @ServiceId
      AND IsActive = 1;

    IF @DurationMinutes IS NULL
    BEGIN
        SELECT
            2 AS ResultCode,
            N'Service not found or inactive.' AS ResultMessage;
        RETURN;
    END;

    SET @EndTime =
        CAST(
            DATEADD(
                MINUTE,
                @DurationMinutes,
                CAST(@StartTime AS DATETIME)
            ) AS TIME(0)
        );

    IF
        @BookingDate < CAST(GETDATE() AS DATE)
        OR
        (
            @BookingDate = CAST(GETDATE() AS DATE)
            AND @StartTime <= CAST(GETDATE() AS TIME(0))
        )
    BEGIN
        SELECT
            3 AS ResultCode,
            N'Booking date/time is in the past.' AS ResultMessage;
        RETURN;
    END;

    IF
        @StartTime < '09:00'
        OR @EndTime > '17:00'
    BEGIN
        SELECT
            4 AS ResultCode,
            N'Booking time is outside business hours.' AS ResultMessage;
        RETURN;
    END;

    BEGIN TRANSACTION;

    IF EXISTS
    (
        SELECT 1
        FROM dbo.Bookings WITH (UPDLOCK, HOLDLOCK)
        WHERE BookingId <> @BookingId
          AND BranchId = @BranchId
          AND BookingDate = @BookingDate
          AND StatusId <> 3
          AND StartTime < @EndTime
          AND EndTime > @StartTime
    )
    BEGIN
        ROLLBACK TRANSACTION;

        SELECT
            5 AS ResultCode,
            N'The selected time is already booked at this branch.' AS ResultMessage;
        RETURN;
    END;

    IF EXISTS
    (
        SELECT 1
        FROM dbo.Bookings WITH (UPDLOCK, HOLDLOCK)
        WHERE BookingId <> @BookingId
          AND UserId = @UserId
          AND BookingDate = @BookingDate
          AND StatusId <> 3
          AND StartTime < @EndTime
          AND EndTime > @StartTime
    )
    BEGIN
        ROLLBACK TRANSACTION;

        SELECT
            6 AS ResultCode,
            N'The user already has a booking at this time.' AS ResultMessage;
        RETURN;
    END;

    UPDATE dbo.Bookings
    SET
        BookingDate = @BookingDate,
        StartTime = @StartTime,
        EndTime = @EndTime,
        UpdatedDate = GETDATE()
    WHERE BookingId = @BookingId;

    COMMIT TRANSACTION;

    SELECT
        0 AS ResultCode,
        N'Booking rescheduled successfully.' AS ResultMessage;
END;
GO


/* ============================================================
   COMPLETE
   ============================================================ */

PRINT 'AppointmentBookings database initialization completed successfully.';
GO