CREATE DATABASE UAA1_MUSEUM
GO

USE UAA1_MUSEUM
GO 

CREATE TABLE Artist(
   Last_Name VARCHAR(50),
   First_Name VARCHAR(50),
   Nickname VARCHAR(50),
   PRIMARY KEY(Last_Name, First_Name, Nickname)
);

CREATE TABLE Hall(
   Hall_Name VARCHAR(50),
   Theme VARCHAR(50),
   PRIMARY KEY(Hall_Name, Theme)
);

CREATE TABLE Art_Piece(
   Art_Piece_Id INT,
   Date_of_Making VARCHAR(50) NOT NULL,
   Press_Note VARCHAR(50) NOT NULL,
   Art_Piece_Name VARCHAR(50) NOT NULL,
   Last_Name VARCHAR(50),
   First_Name VARCHAR(50),
   Nickname VARCHAR(50),
   PRIMARY KEY(Art_Piece_Id),
   UNIQUE(Date_of_Making),
   UNIQUE(Press_Note),
   UNIQUE(Art_Piece_Name),
   FOREIGN KEY(Last_Name, First_Name, Nickname) REFERENCES Artist(Last_Name, First_Name, Nickname)
);

CREATE TABLE Transition_ID(
   Location_Identifier VARCHAR(50),
   Start_Date DATETIME NOT NULL,
   Exit_Date DATETIME NOT NULL,
   Art_Piece_Id INT NOT NULL,
   Hall_Name VARCHAR(50) NOT NULL,
   Theme VARCHAR(50) NOT NULL,
   PRIMARY KEY(Location_Identifier),
   UNIQUE(Start_Date),
   UNIQUE(Exit_Date),
   FOREIGN KEY(Art_Piece_Id) REFERENCES Art_Piece(Art_Piece_Id),
   FOREIGN KEY(Hall_Name, Theme) REFERENCES Hall(Hall_Name, Theme)
);
--creation index of art piece
CREATE INDEX [ART_PIECE_NAME]
ON [Art_piece]([Art_Piece_Name])

CREATE INDEX [ARTIST_IDENTIFIER]
ON [Artist]([Last_Name]DESC, [First_Name]DESC, [Nickname]DESC)

--PROCEDURE CREATION = MOVEPIECE OF ART


go
CREATE PROCEDURE [SP_MOVE_ART_PIECE](

	@EXIT_DATE DATETIME NOT NULL,
	@START_DATE DATETIME NOT NULL,
	@HALLNAME VARCHAR(50) NOT NULL,
	@THEME VARCHAR(50) NOT NULL
)
AS 
BEGIN

	DECLARE @ART_PIECE_ID INT NOT NULL;

	DECLARE @LOCATION_IDENTIFIER VARCHAR(50) NOT NULL;


			BEGIN TRANSACTION

					UPDATE [Transition_ID]
					SET @EXIT_DATE = GETDATE()
					WHERE Art_Piece_Id LIKE @ART_PIECE_ID AND Exit_Date IS NULL;


				IF NOT EXISTS (SELECT Exit_Date FROM Transition_ID WHERE Art_Piece_Id = @ART_PIECE_ID )
					BEGIN
						IF(@EXIT_DATE IS NULL)
							BEGIN	
								INSERT INTO [Transition_ID]([Start_Date],[Hall_Name],[Theme])
								VALUES(@START_DATE, @HALLNAME, @THEME )
							END
					END
				ELSE
					ROLLBACK TRANSACTION
END


