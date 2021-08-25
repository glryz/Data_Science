CREATE DATABASE Library1;
--Create Two Schemas
CREATE SCHEMA Book;
---
CREATE SCHEMA Person;
--create Book.Book table

GO
Use Library1;
CREATE TABLE Book.Book (
								Book_ID int PRIMARY KEY NOT NULL,
								Book_Name nvarchar(50) NULL
								);
--create Book.Author table
CREATE TABLE Book.Author (
								Author_ID int PRIMARY KEY NOT NULL,
								Author_Name nvarchar(50) NULL
								);
--create Book.Book_Author table
CREATE TABLE Book.Book_Author (
								Book_ID INT PRIMARY KEY,
								Author_ID INT NOT NULL
							    );
--create Publisher Table
CREATE TABLE Book.Publisher (
								Publisher_ID int PRIMARY KEY IDENTITY(1,1) NOT NULL,
								Publisher_Name nvarchar(100) NULL
								);
--create Book_Publisher table
CREATE TABLE Book.Book_Publisher (
								Book_ID int PRIMARY KEY NOT NULL,
								Publisher_ID int NOT NULL
								);
--create Person.Person table
CREATE TABLE Person.Person (
								Person_ID bigint PRIMARY KEY NOT NULL,
								Person_Name nvarchar(50) NULL,
								Person_Surname nvarchar(50) NULL
								);

CREATE TABLE Person.Person_Book (
								Person_ID bigint NOT NULL,
								Book_ID int NOT NULL
								);

--create Person_Mail table
CREATE TABLE Person.Person_Mail(
								Mail_ID int Primary Key identity(1,1) NOT NULL,
								E_Mail text NOT NULL,
								Person_ID bigint NOT NULL
								);
--create Person_Phone table
CREATE TABLE Person.Person_Phone(
								Phone_Number bigint PRIMARY KEY NOT NULL,
								Person_ID bigint NOT NULL	
								);

SELECT *
FROM Person.Person

----------INSERT

----!!! ilgili kolonun özelliklerine ve kýsýtlarýna uygun veri girilmeli !!!


-- Insert iþlemi yapacaðýnýz tablo sütunlarýný aþaðýdaki gibi parantez içinde belirtebilirsiniz.
-- Bu kullanýmda sadece belirttiðiniz sütunlara deðer girmek zorundasýnýz. Sütun sýrasý önem arz etmektedir.

INSERT INTO Person.Person (Person_ID, Person_Name, Person_Surname) VALUES (75056659595,'Zehra', 'Tekin')

INSERT INTO Person.Person (Person_ID, Person_Name) VALUES (889623212466,'Kerem')


--Eðer bir tablodaki tüm sütunlara insert etmeyecekseniz, seçtiðiniz sütunlarýn haricindeki sütunlar Nullable olmalý.
--Eðer Not Null constrainti uygulanmýþ sütun varsa hata verecektir.

--Aþaðýda Person_Surname sütununa deðer girilmemiþtir. 
--Person_Surname sütunu Nullable olduðu için Person_Surname yerine Null deðer atayarak iþlemi tamamlar.

INSERT INTO Person.Person (Person_ID, Person_Name) VALUES (78962212466,'Kerem')

--Insert edeceðim deðerler tablo kýsýtlarýna ve sütun veri tiplerine uygun olmazsa aþaðýdaki gibi iþlemi gerçekleþtirmez.


--Insert keywordunden sonra Into kullanmanýza gerek yoktur.
--Ayrýca Aþaðýda olduðu gibi insert etmek istediðiniz sütunlarý belirtmeyebilirsiniz. 
--Buna raðmen sütun sýrasýna ve yukarýdaki kurallara dikkat etmelisiniz.
--Bu kullanýmda tablonun tüm sütunlarýna insert edileceði farz edilir ve sizden tüm sütunlar için deðer ister.

INSERT Person.Person VALUES (15078893526,'Mert','Yetiþ')

--Eðer deðeri bilinmeyen sütunlar varsa bunlar yerine Null yazabilirsiniz. 
--Tabiki Null yazmak istediðiniz bu sütunlar Nullable olmalýdýr.

INSERT Person.Person VALUES (55556698752, 'Esra', Null)



--Ayný anda birden fazla kayýt insert etmek isterseniz;

INSERT Person.Person VALUES (35532888963,'Ali','Tekin');-- Tüm tablolara deðer atanacaðý varsayýlmýþtýr.
INSERT Person.Person VALUES (88232556264,'Metin','Sakin')


--Ayný tablonun ayný sütunlarýna birçok kayýt insert etmek isterseniz aþaðýdaki syntaxý kullanabilirsiniz.
--Burada dikkat edeceðiniz diðer bir konu Mail_ID sütununa deðer atanmadýðýdýr.
--Mail_ID sütunu tablo oluþturulurken identity olarak tanýmlandýðý için otomatik artan deðerler içerir.
--Otomatik artan bir sütuna deðer insert edilmesine izin verilmez.

INSERT INTO Person.Person_Mail (E_Mail, Person_ID) 
VALUES ('zehtek@gmail.com', 75056659595),
	   ('meyet@gmail.com', 15078893526),
	   ('metsak@gmail.com', 35532558963)

--Yukarýdaki syntax ile aþaðýdaki fonksiyonlarý çalýþtýrdýðýnýzda,
--Yaptýðýnýz son insert iþleminde tabloya eklenen son kaydýn identity' sini ve tabloda etkilenen kayýt sayýsýný getirirler.
--Not: fonksiyonlarý teker teker çalýþtýrýn.

SELECT @@IDENTITY--last process last identity number
SELECT @@ROWCOUNT--last process row count



--Aþaðýdaki syntax ile farklý bir tablodaki deðerleri daha önceden oluþturmuþ olduðunuz farklý bir tabloya insert edebilirsiniz.
--Sütun sýrasý, tipi, constraintler ve diðer kurallar yine önemli.

select * into Person.Person_2 from Person.Person-- Person_2 þeklinde yedek bir tablo oluþturun


INSERT Person.Person_2 (Person_ID, Person_Name, Person_Surname)
SELECT * FROM Person.Person where Person_name like 'M%'


--Aþaðýdaki syntaxda göreceðiniz üzere hiçbir deðer belirtilmemiþ. 
--Bu þekilde tabloya tablonun default deðerleriyle insert iþlemi yapýlacaktýr.
--Tabiki sütun constraintleri buna elveriþli olmalý. 

INSERT Book.Publisher
DEFAULT VALUES



--update



--Update iþleminde koþul tanýmlamaya dikkat ediniz. Eðer herhangi bir koþul tanýmlamazsanýz 
--Sütundaki tüm deðerlere deðiþiklik uygulanacaktýr.

-- update yaparken dikkatli olmak gerekiyor. yeni oluþturulan sütuna update te sorun olmaz ama var olan bir 
	--sütuna update yaparken where koþulu ile yapmakta fayda var.


UPDATE Person.Person_2 SET Person_Name = 'Default_Name'--burayý çalýþtýrmadan önce yukarýdaki scripti çalýþtýrýn

--Where ile koþul vererek 88963212466 Person_ID ' ye sahip kiþinin adýný Can þeklinde güncelliyoruz.
--Kiþinin önceki Adý Kerem' di.

UPDATE Person.Person_2 SET Person_Name = 'Can' WHERE Person_ID = 78962212466


select * from Person.Person_2




--Join ile update

----Aþaðýda Person_2 tablosunda person id' si 78962212466 olan þahsýn (yukarýdaki þahýs) adýný,
----Asýl tablomuz olan Person tablosundaki haliyle deðiþtiriyoruz.
----Bu iþlemi yaparken iki tabloyu Person_ID üzerinden Join ile birleþtiriyoruz
----Ve kaynak tablodaki Person_ID' ye istediðimiz þartý veriyoruz.

UPDATE Person.Person_2 SET Person_Name = B.Person_Name 
FROM Person.Person_2 A Inner Join Person.Person B ON A.Person_ID=B.Person_ID
WHERE B.Person_ID = 78962212466


--Subquery ile Update

--Aþaðýda Person_2 tablosundaki bir ismin deðerini bir sorgu neticesinde gelen bir deðere eþitleme iþlemi yapýlmaktadýr.

UPDATE Person.Person_2 SET Person_Name = (SELECT Person_Name FROM Person.Person where Person_ID = 78962212466) WHERE Person_ID = 78962212466

select * from Person.Person_2

---
----delete


--Delete' nin ne anlama geldiðini artýk biliyor olmalýsýnýz.
--Delete kullanýmýnda, Delete ile tüm verilerini sildiðiniz bir tabloya yeni bir kayýt eklediðinizde,
--Eðer tablonuzda otomatik artan bir identity sütunu var ise eklenen yeni kaydýn identity'si, 
--silinen son kaydýn identity'sinden sonra devam edecektir.


--örneðin aþaðýda otomatik artan bir identity primary keye sahip Book.Publisher tablosuna örnek olarak veri ekleniyor.

insert Book.Publisher values ('Ýþ Bankasý Kültür Yayýncýlýk'), 
							 ('Can Yayýncýlýk'), 
							 ('Ýletiþim Yayýncýlýk')

select *
from Book.publisher

--Delete ile Book.Publisher tablosunun içi tekrar boþaltýlýyor.

Delete from Book.Publisher 

--kontrol
select * from Book.Publisher 

--Book.Publisher tablosuna yeni bir veri insert ediliyor
insert Book.Publisher values ('Paris')

--Tekrar kontrol ettiðimizde yeni insert edilen kaydýn identity'sinin eski tablodaki sýradan devam ettiði görülecektir.
select * from Book.Publisher



---/////////////////////////////

--//////////////////////////////


--Buradan sonraki kýsýmda Constraint ve Alter Table örnekleri yapýlacaktýr.
--Yapacaðýmýz iþlemlerin tutarlý olmasý için öncelikle yukarýda örnek olarak veri insert ettiðimiz tablolarýmýzý boþaltalým.


DROP TABLE Person.Person_2;--Artýk ihtiyacýmýz yok.

TRUNCATE TABLE Person.Person_Mail;
TRUNCATE TABLE Person.Person;
TRUNCATE TABLE Book.Publisher;






--ALTER TABLE

SELECT Person_Name, Person_Surname INTO Sample_Person FROM Person.Person


SP_Rename 'dbo.Sample_Person', 'Person_New'

sp_rename 'Person_New.Person_Name', 'First_Name', 'Column'


---------Book tablomuz bir primary key' e sahip


---------Author

--Author tablomuza primary key atamamýz gerekli, çünkü oluþtururken atanmamýþ


ALTER TABLE Book.Author ADD CONSTRAINT pk_author PRIMARY KEY (Author_ID)
-- sütun not null özelliðinde olmadýðý için PRIMARY KEY atamadý. hata verdi

Alter table Book.Author alter column Author_ID int not null
-- sütuna not null constraint i girdik.

ALTER TABLE Book.Author ADD CONSTRAINT pk_author PRIMARY KEY (Author_ID)
-- þimdi PRIMARY KEY olarak atadý.

---------Book_Author tablosuna foreign key constraint eklemeliyiz


ALTER TABLE Book.Book_Author ADD CONSTRAINT FK_Author FOREIGN KEY (Author_ID) REFERENCES Book.Author (Author_ID)
ON UPDATE NO ACTION -- update iþlemlerinde herhangi bir deðiþiklik yapma
ON DELETE NO ACTION -- delete iþlemlerinde ayný deðiþikliði uygula


ALTER TABLE Book.Book_Author ADD CONSTRAINT FK_Book2 FOREIGN KEY (Book_ID) REFERENCES Book.Book (Book_ID)
ON UPDATE NO ACTION
ON DELETE CASCADE


--Publisher tablosu normal.


--Book_Publisher tablosuna iki tane Foreign key constraint eklememiz gerekiyor.

ALTER TABLE Book.Book_Publisher ADD CONSTRAINT FK_Publisher FOREIGN KEY (Publisher_ID) REFERENCES Book.Publisher (Publisher_ID)

ALTER TABLE Book.Book_Publisher ADD CONSTRAINT FK_Book FOREIGN KEY (Book_ID) REFERENCES Book.Book (Book_ID)

--Person.Person tablosundaki Person_ID sütununa 11 haneli olmasý gerektiði için check constraint ekleyelim.


Alter table Person.Person add constraint FK_PersonID_check Check (Person_ID between 9999999999 and 99999999999)

--Alttaki constraint' te check ile bir fonksiyonun doðrulanma durumunu sorguluyoruz.
--Fonksiyon gerçek hayatta kullanýlan TC kimlik no algoritmasýný çalýþtýrýyor.
--Yapýlan check kontrolu bu fonksiyonun süzgecinden geçiyor, eðer ID numarasý fonksiyona uyuyorsa fonksiyon 1 deðeri üretiyor ve
--iþlem gerçekleþtiriliyor. Fonksiyon 0 deðerini üretirse bu ID numarasýnýn istenen koþullarý saðlamadýðý anlamýna geliyor ve 
--Ýþlem yapýlmýyor.
--Fonksiyonu çalýþtýrabilmeniz için FONKSÝYONU BU DATABASE ALTINDA CREATE ETMENÝZ gerekmektedir.
--Fonksiyonun scriptini ayrýca göndereceðim.

-------------------SCRIPT-----------------
CREATE FUNCTION dbo.[KIMLIKNO_KONTROL](@TcNo Bigint)
RETURNS BIT
AS
BEGIN
      DECLARE @ATCNO Bigint
      DECLARE @BTCNO Bigint
      DECLARE @C1    Tinyint
      DECLARE @C2    Tinyint
      DECLARE @C3    Tinyint
      DECLARE @C4    Tinyint
      DECLARE @C5    Tinyint
      DECLARE @C6    Tinyint
      DECLARE @C7    Tinyint
      DECLARE @C8    Tinyint
      DECLARE @C9    Tinyint
      DECLARE @Q1    Int
      DECLARE @Q2    Int
      DECLARE @SONUC Bit
      SET @ATCNO = @TcNo / 100
      SET @BTCNO = @TcNo / 100
      IF LEN(CONVERT(VARCHAR(19),@TcNo)) = 11
      BEGIN
            SET @C1 = @ATCNO % 10 SET @ATCNO = @ATCNO / 10
            SET @C2 = @ATCNO % 10 SET @ATCNO = @ATCNO / 10
            SET @C3 = @ATCNO % 10 SET @ATCNO = @ATCNO / 10
            SET @C4 = @ATCNO % 10 SET @ATCNO = @ATCNO / 10
            SET @C5 = @ATCNO % 10 SET @ATCNO = @ATCNO / 10
            SET @C6 = @ATCNO % 10 SET @ATCNO = @ATCNO / 10
            SET @C7 = @ATCNO % 10 SET @ATCNO = @ATCNO / 10
            SET @C8 = @ATCNO % 10 SET @ATCNO = @ATCNO / 10
            SET @C9 = @ATCNO % 10 SET @ATCNO = @ATCNO / 10
            SET @Q1 = ((10-((((@C1+@C3+@C5+@C7+@C9)*3)+(@C2+@C4+@C6+@C8)) % 10))%10)
            SET @Q2 = ((10-(((((@C2+@C4+@C6+@C8)+@Q1)*3)+(@C1+@C3+@C5+@C7+@C9))%10))%10)
            IF (@BTCNO * 100)+(@Q1 * 10)+@Q2 = @TcNo SET @SONUC = 1 ELSE SET @SONUC = 0
      END
      ELSE SET @SONUC = 0
RETURN @SONUC
END


Alter table Person.Person add constraint FK_PersonID_check2 Check (dbo.KIMLIKNO_KONTROL(Person_ID) = 1)


--Person_Book 

--Person_Book tablosuna Composite bir primary key eklememiz gerekmektedir.
--sonrasýnda iki ID sütununa Foreign key constraint tanýmlamlayalým.


Alter table Person.Person_Book add constraint PK_Person Primary Key (Person_ID,Book_ID)


Alter table Person.Person_Book add constraint FK_Person1 Foreign key (Person_ID) References Person.Person(Person_ID)

Alter table Person.Person_Book add constraint FK_Book1 Foreign key (Book_ID) References Book.Book(Book_ID)


---------Person.Person_Phone

--Person_Phone tablosuna person_ID için foreign key constraint oluþturmamýz gerekli.

Alter table Person.Person_Phone add constraint FK_Person3 Foreign key (Person_ID) References Person.Person(Person_ID)

--Phone_Number için check...

Alter table Person.Person_Phone add constraint FK_Phone_check Check (Phone_Number between 999999999 and 9999999999)

--

-------------Person.Person_Mail için Foreign key tanýmlamamýz gerekli

Alter table Person.Person_Mail add constraint FK_Person4 Foreign key (Person_ID) References Person.Person(Person_ID)


---Bu aþamada Database diagramýnýzý çizip tüm tablolar arasýndaki baðlantýlarýn oluþtuðundan emin olmanýzý bekliyorum.


--Insert iþlemlerini size býrakýyorum, hata alarak, constraintlerin ne anlama geldiðini kendiniz tecrübe ederek yapmanýz daha deðerli.











