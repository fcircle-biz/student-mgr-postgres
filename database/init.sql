-- ========================================================
-- ユーザーの作成
-- ========================================================
CREATE USER "student-mgr" WITH PASSWORD 'student-mgr' SUPERUSER;

-- ========================================================
-- DBの作成
-- ========================================================
CREATE DATABASE "student-mgr-db" OWNER "student-mgr";

-- ========================================================
-- データベースを切り替え
-- ========================================================
\c "student-mgr-db"

-- ========================================================
-- テーブルの作成
-- ========================================================

-- 生徒マスタ
CREATE TABLE m_student
(
     student_id integer NOT NULL
   , student_name varchar(30) NOT NULL
   , gender_cd char(1) NOT NULL
   , pref_cd varchar(2)
   , age integer
   , birthday date
   , primary key(student_id)
);

-- 生徒別履修教科マスタ
CREATE TABLE t_receive_subject
(
     student_id integer NOT NULL
   , subject_cd char(2)
   , primary key(student_id,subject_cd)
);

-- 教科マスタ
CREATE TABLE m_subject
(
     subject_cd char(2) NOT NULL
   , subject_name varchar(20) NOT NULL
   , primary key(subject_cd)
);

-- 性別マスタ
CREATE TABLE m_gender
(
     gender_cd char(1) NOT NULL
   , gender_name varchar(2) NOT NULL
   , primary key(gender_cd)
);

-- 都道府県マスタ
CREATE TABLE m_pref
(
     pref_cd varchar(2)
   , pref_name varchar(20) NOT NULL
   , primary key(pref_cd)
);

-- ========================================================
-- シーケンス
-- ========================================================

CREATE SEQUENCE student_id_seq START 1000;

-- ========================================================
-- ビュー
-- ========================================================

CREATE VIEW v_student AS

    SELECT s.student_id     AS 生徒ID
         , s.student_name   AS 生徒名
         , g.gender_name    AS 性別
         , s.age            AS 年齢
         , s.birthday       AS 生年月日
         , p.pref_name      AS 都道府県
         , sbj.subject_name AS 履修教科
      FROM m_student s
      
INNER JOIN t_receive_subject r
        ON s.student_id = r.student_id
 LEFT JOIN m_gender g
        ON s.gender_cd = g.gender_cd
 LEFT JOIN m_pref p
        ON s.pref_cd = p.pref_cd
 LEFT JOIN m_subject sbj
        ON r.subject_cd = sbj.subject_cd;


-- ========================================================
-- データ登録
-- ========================================================

COPY m_student
FROM '/docker-entrypoint-initdb.d/public.m_student.csv'
WITH (
  FORMAT CSV,
  HEADER true,
  NULL ''
);

COPY t_receive_subject
FROM '/docker-entrypoint-initdb.d/public.t_receive_subject.csv'
WITH (
  FORMAT CSV,
  HEADER true,
  NULL ''
);

COPY m_pref
FROM '/docker-entrypoint-initdb.d/public.m_pref.csv'
WITH (
  FORMAT CSV,
  HEADER true,
  NULL ''
);

COPY m_gender
FROM '/docker-entrypoint-initdb.d/public.m_gender.csv'
WITH (
  FORMAT CSV,
  HEADER true,
  NULL ''
);

COPY m_subject
FROM '/docker-entrypoint-initdb.d/public.m_subject.csv'
WITH (
  FORMAT CSV,
  HEADER true,
  NULL ''
);
