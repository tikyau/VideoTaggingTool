
/****** Object:  Table [dbo].[Frames]    Script Date: 1/3/2016 11:30:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Frames](
	[JobId] [int] NOT NULL,
	[FrameIndex] [bigint] NOT NULL,
	[TagsJson] [ntext] NULL,
 CONSTRAINT [PK_Frames] PRIMARY KEY CLUSTERED 
(
	[JobId] ASC,
	[FrameIndex] ASC
)
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Jobs]    Script Date: 1/3/2016 11:30:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Jobs](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[VideoId] [int] NOT NULL,
	[UserId] [int] NOT NULL,
	[Description] [nvarchar](1024) NULL,
	[CreatedById] [int] NULL,
	[ReviewedById] [int] NULL,
	[ConfigJson] [ntext] NULL,
	[CreateDate] [datetime] NOT NULL,
	[StatusId] [tinyint] NOT NULL,
 CONSTRAINT [PK_Jobs] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[JobStatus]    Script Date: 1/3/2016 11:30:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JobStatus](
	[Id] [tinyint] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](100) NULL,
 CONSTRAINT [PK_JobStatus] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Roles]    Script Date: 1/3/2016 11:30:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Roles](
	[Id] [tinyint] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Description] [nchar](1024) NULL,
 CONSTRAINT [PK_Roles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Users]    Script Date: 1/3/2016 11:30:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Users](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Email] [varchar](100) NOT NULL,
	[RoleId] [tinyint] NOT NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Videos]    Script Date: 1/3/2016 11:30:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Videos](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Width] [int] NOT NULL,
	[Height] [int] NOT NULL,
	[DurationSeconds] [real] NOT NULL,
	[FramesPerSecond] [real] NOT NULL,
	[VideoJson] [ntext] NULL,
 CONSTRAINT [PK_Videos] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Index [IX_Jobs]    Script Date: 1/3/2016 11:30:41 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Jobs] ON [dbo].[Jobs]
(
	[UserId] ASC,
	[VideoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_Users_Email]    Script Date: 1/3/2016 11:30:41 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Users_Email] ON [dbo].[Users]
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Frames]  WITH CHECK ADD  CONSTRAINT [FK_Frames_Jobs] FOREIGN KEY([JobId])
REFERENCES [dbo].[Jobs] ([Id])
GO
ALTER TABLE [dbo].[Frames] CHECK CONSTRAINT [FK_Frames_Jobs]
GO
ALTER TABLE [dbo].[Jobs]  WITH CHECK ADD  CONSTRAINT [FK_Jobs_JobStatus] FOREIGN KEY([StatusId])
REFERENCES [dbo].[JobStatus] ([Id])
GO
ALTER TABLE [dbo].[Jobs] CHECK CONSTRAINT [FK_Jobs_JobStatus]
GO
ALTER TABLE [dbo].[Jobs]  WITH CHECK ADD  CONSTRAINT [FK_Jobs_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[Jobs] CHECK CONSTRAINT [FK_Jobs_Users]
GO
ALTER TABLE [dbo].[Jobs]  WITH CHECK ADD  CONSTRAINT [FK_Jobs_Users_CreatedById] FOREIGN KEY([CreatedById])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[Jobs] CHECK CONSTRAINT [FK_Jobs_Users_CreatedById]
GO
ALTER TABLE [dbo].[Jobs]  WITH CHECK ADD  CONSTRAINT [FK_Jobs_Users_ReviewedByAdmin] FOREIGN KEY([ReviewedById])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[Jobs] CHECK CONSTRAINT [FK_Jobs_Users_ReviewedByAdmin]
GO
ALTER TABLE [dbo].[Jobs]  WITH CHECK ADD  CONSTRAINT [FK_Jobs_Videos] FOREIGN KEY([VideoId])
REFERENCES [dbo].[Videos] ([Id])
GO
ALTER TABLE [dbo].[Jobs] CHECK CONSTRAINT [FK_Jobs_Videos]
GO
ALTER TABLE [dbo].[Users]  WITH CHECK ADD  CONSTRAINT [FK_Users_Roles] FOREIGN KEY([RoleId])
REFERENCES [dbo].[Roles] ([Id])
GO
ALTER TABLE [dbo].[Users] CHECK CONSTRAINT [FK_Users_Roles]
GO
/****** Object:  StoredProcedure [dbo].[GetAllJobs]    Script Date: 1/3/2016 11:30:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetAllJobs]
AS
BEGIN
	SELECT	j.Id as JobId, j.Description, j.CreatedById, u1.Name as CreatedByName, j.UserId, u3.Name as UserName, j.ReviewedById, u2.Name as ReviewedByName, j.CreateDate, 'TODO' as Progress,
			j.ConfigJson, j.StatusId, js.Name as StatusName, v.Id as VideoId, v.Name as VideoName, v.Width, v.Height, v.DurationSeconds, v.FramesPerSecond, v.VideoJson
	FROM Jobs j
	JOIN Videos v
	ON j.VideoId = v.Id
	LEFT JOIN USERS u1 ON j.CreatedById = u1.Id
	LEFT JOIN USERS u2 ON j.ReviewedById = u2.Id
	LEFT JOIN USERS u3 ON j.UserId = u3.Id
	JOIN JobStatus js ON js.Id = j.StatusId
END



GO
/****** Object:  StoredProcedure [dbo].[GetJob]    Script Date: 1/3/2016 11:30:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetJob]
	@Id int
AS
BEGIN

	DECLARE @UserId int = -1
	DECLARE @VideoId int = 0

	SELECT @UserId = j.UserId, @VideoId = j.VideoId
	FROM Jobs j
	WHERE j.Id = @Id

	SELECT * FROM Jobs WHERE Id = @Id

	SELECT * FROM Videos WHERE Id = @VideoId

	SELECT * FROM Users WHERE Id = @UserId

	SELECT * FROM Frames WHERE JobId = @Id

	RETURN 1

END



GO
/****** Object:  StoredProcedure [dbo].[GetJobStatuses]    Script Date: 1/3/2016 11:30:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetJobStatuses]
AS
BEGIN

	SELECT *
	FROM JobStatus

END

GO
/****** Object:  StoredProcedure [dbo].[GetRoles]    Script Date: 1/3/2016 11:30:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetRoles]
AS
BEGIN

	SELECT *
	FROM Roles

END

GO
/****** Object:  StoredProcedure [dbo].[GetUserByEmail]    Script Date: 1/3/2016 11:30:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetUserByEmail]
	@Email varchar(100)
AS
BEGIN

	SELECT u.*, r.Name as RoleName
	FROM Users u
	JOIN Roles r
	ON u.RoleId = r.Id
	WHERE u.Email = @Email

	RETURN 1

END



GO
/****** Object:  StoredProcedure [dbo].[GetUserById]    Script Date: 1/3/2016 11:30:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetUserById]
	@Id int
AS
BEGIN

	SELECT u.*, r.Name as RoleName
	FROM Users u
	JOIN Roles r
	ON u.RoleId = r.Id
	WHERE u.Id = @Id

	RETURN 1

END



GO
/****** Object:  StoredProcedure [dbo].[GetUserJobs]    Script Date: 1/3/2016 11:30:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetUserJobs]
	@UserId int
AS
BEGIN
	SELECT	j.Id as JobId, j.Description, j.CreatedById, u1.Name as CreatedByName, j.UserId, u3.Name as UserName, j.ReviewedById, u2.Name as ReviewedByName, j.CreateDate, 40 as Progress,
			j.ConfigJson, j.StatusId, js.Name as StatusName, v.Id as VideoId, v.Name as VideoName, v.Width, v.Height, v.DurationSeconds, v.FramesPerSecond, v.VideoJson
	FROM Jobs j
	JOIN Videos v
	ON j.UserId = @UserId AND j.VideoId = v.Id
	LEFT JOIN USERS u1 ON j.CreatedById = u1.Id
	LEFT JOIN USERS u2 ON j.ReviewedById = u2.Id
	LEFT JOIN USERS u3 ON j.UserId = u3.Id
	JOIN JobStatus js ON js.Id = j.StatusId
END


GO
/****** Object:  StoredProcedure [dbo].[GetUsers]    Script Date: 1/3/2016 11:30:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetUsers]
AS

BEGIN

	SELECT u.*, r.Name as RoleName
	FROM Users u
	JOIN Roles r
	ON u.RoleId = r.Id

END


GO
/****** Object:  StoredProcedure [dbo].[GetVideo]    Script Date: 1/3/2016 11:30:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetVideo]
	@Id int
AS
BEGIN
	SELECT	*
	FROM Videos
	WHERE Id = @Id
END



GO
/****** Object:  StoredProcedure [dbo].[GetVideoFrames]    Script Date: 1/3/2016 11:30:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetVideoFrames]
@VideoId int
AS

BEGIN

	SELECT f.*
	FROM Jobs j
	JOIN Frames f
	ON j.Id = f.JobId
	WHERE j.VideoId = @VideoId
    ORDER BY f.FrameIndex ASC

END



GO
/****** Object:  StoredProcedure [dbo].[GetVideoFramesByJob]    Script Date: 1/3/2016 11:30:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetVideoFramesByJob]
@JobId int
AS

BEGIN

	SELECT f.*
	FROM Jobs j
	JOIN Frames f
	ON j.Id = f.JobId
	WHERE j.Id = @JobId
    ORDER BY f.FrameIndex ASC

END



GO
/****** Object:  StoredProcedure [dbo].[GetVideos]    Script Date: 1/3/2016 11:30:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetVideos]
AS

BEGIN

	SELECT *  FROM [dbo].[Videos]

END


GO
/****** Object:  StoredProcedure [dbo].[UpdateJobStatus]    Script Date: 1/3/2016 11:30:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[UpdateJobStatus]
	@Id int = -1,
	@UserId int = -1,
	@StatusId tinyint
AS
BEGIN

	SET NOCOUNT ON;


	if @UserId != -1 AND @StatusId=3 /* APPROVED */
	BEGIN
		UPDATE Jobs
		SET StatusId = @StatusId, ReviewedById = @UserId
		WHERE Id = @Id
	END
	ELSE
	BEGIN
		UPDATE Jobs
		SET StatusId = @StatusId, ReviewedById = NULL
		WHERE Id = @Id
	END

END

GO
/****** Object:  StoredProcedure [dbo].[UpsertFrame]    Script Date: 1/3/2016 11:30:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpsertFrame]
	@JobId int,
	@FrameIndex bigint,
	@TagsJson ntext
AS
BEGIN

	SET NOCOUNT ON;


	BEGIN TRANSACTION T1


	IF EXISTS (SELECT * FROM Frames WHERE JobId = @JobId AND FrameIndex = @FrameIndex)
	BEGIN
		UPDATE [Frames]
		SET	TagsJson = @TagsJson
		WHERE JobId = @JobId AND FrameIndex = @FrameIndex
	END
	ELSE
	BEGIN

	INSERT INTO [dbo].[Frames]
           ([JobId]
           ,[FrameIndex]
		   ,[TagsJson])
     VALUES
           (@JobId
           ,@FrameIndex
		   ,@TagsJson)
	END

	COMMIT TRANSACTION T1

END


GO
/****** Object:  StoredProcedure [dbo].[UpsertJob]    Script Date: 1/3/2016 11:30:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[UpsertJob]
	-- Add the parameters for the stored procedure here
	@Id int = -1,
	@VideoId int,
	@UserId int,
	@Description nvarchar(1024),
	@CreatedById int,
	@StatusId tinyint,
	@ConfigJson ntext,
	@JobId int OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRANSACTION T1


	IF @Id IS NOT NULL AND EXISTS (
		SELECT * FROM Jobs
		WHERE	Id = @Id
	)
	BEGIN
		UPDATE [Jobs]
		SET	VideoId = @VideoId
			,UserId = @UserId
			,[Description] = @Description
			,CreatedById = @CreatedById
			,StatusId = @StatusId
			,ConfigJson = @ConfigJson
		WHERE	Id = @Id

		SET @JobId = @Id
	END
	ELSE
	BEGIN

	INSERT INTO [dbo].[Jobs]
           ([VideoId]
           ,[UserId]
		   ,[Description]
           ,[CreatedById]
		   ,[StatusId]
           ,[CreateDate]
		   ,[ConfigJson]
		   )
     VALUES
           (@VideoId
           ,@UserId
		   ,@Description
           ,@CreatedById
		   ,@StatusId
		   ,GETDATE()
           ,@ConfigJson)
	END

	SET @JobId = (SELECT Id FROM Jobs WHERE VideoId = @VideoId AND UserId = @UserId)

	COMMIT TRANSACTION T1

END


GO
/****** Object:  StoredProcedure [dbo].[UpsertUser]    Script Date: 1/3/2016 11:30:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[UpsertUser]
	@Id int = -1,
	@Name nvarchar(50),
	@Email varchar(100),
	@RoleId tinyint,
	@UserId int OUTPUT
AS
BEGIN
	
	IF @Id IS NOT NULL AND EXISTS (
		SELECT * FROM Users
		WHERE	Id = @Id
	)
	BEGIN
		UPDATE [Users]
		SET	 Name = @Name
			,Email = @Email
			,RoleId = @RoleId
		WHERE Id = @Id

		SET @UserId = @Id
	END
	ELSE
	BEGIN

		INSERT INTO [dbo].[Users]
			   ([Name]
			   ,[Email]
			   ,[RoleId])
		 VALUES
			   (@Name
			   ,@Email
			   ,@RoleId)

		SET @UserId = (SELECT @@IDENTITY)
	END

END


GO
/****** Object:  StoredProcedure [dbo].[UpsertVideo]    Script Date: 1/3/2016 11:30:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[UpsertVideo]
	-- Add the parameters for the stored procedure here
	@Id int = -1,
	@Name nvarchar(100),
	@Width int,
	@Height int,
	@DurationSeconds real,
	@FramesPerSecond real,
	@VideoJson ntext = NULL,
	@VideoId int OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRANSACTION T1


	IF @Id IS NOT NULL AND EXISTS (
		SELECT * FROM Videos
		WHERE	Id = @Id
	)
	BEGIN
		UPDATE [Videos]
		SET	Name = @Name
			,Width = @Width
			,Height = @Height
			,DurationSeconds = @DurationSeconds
			,FramesPerSecond = @FramesPerSecond
			,VideoJson = @VideoJson
		WHERE	Id = @Id

		SET @VideoId = @Id
	END
	ELSE
	BEGIN

		INSERT INTO [dbo].[Videos]
			   ([Name]
			   ,[Width]
			   ,[Height]
			   ,[DurationSeconds]
			   ,[FramesPerSecond]
			   ,[VideoJson])
		 VALUES
			   (@Name
			   ,@Width
			   ,@Height
			   ,@DurationSeconds
			   ,@FramesPerSecond
			   ,@VideoJson)


		SET @VideoId = (SELECT @@IDENTITY)
	END

	COMMIT TRANSACTION T1

END
