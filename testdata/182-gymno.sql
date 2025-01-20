PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE version (id TEXT NOT NULL) STRICT;
INSERT INTO version VALUES('v0.3.21');
CREATE TABLE metadata (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  doi TEXT DEFAULT '',
  title TEXT NOT NULL,
  alias TEXT DEFAULT '',
  description TEXT DEFAULT '',
  issued TEXT DEFAULT '',
  version TEXT DEFAULT '',
  keywords TEXT DEFAULT '',
  geographic_scope TEXT DEFAULT '',
  taxonomic_scope TEXT DEFAULT '',
  temporal_scope TEXT DEFAULT '',
  confidence INTEGER DEFAULT NULL,
  completeness INTEGER DEFAULT NULL,
  license TEXT DEFAULT '',
  url TEXT DEFAULT '',
  logo TEXT DEFAULT '',
  label TEXT DEFAULT '',
  citation TEXT DEFAULT '',
  private INTEGER DEFAULT NULL -- bool 
) STRICT;
INSERT INTO metadata VALUES(1,'','Gymno','','This classification is primarily focused on Gymnodinium, a genus of dinoflagellate. I tried to include all Gymnodinium name strings (even invalid names and lexical variants).','','','','','','',NULL,NULL,'','','','','',0);
CREATE TABLE contact (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  metadata_id INTEGER DEFAULT 1,
  orcid TEXT DEFAULT '',
  given TEXT NOT NULL,
  family TEXT NOT NULL,
  rorid TEXT DEFAULT '',
  organisation TEXT DEFAULT '',
  email TEXT NOT NULL,
  url TEXT DEFAULT '',
  note TEXT DEFAULT ''
) STRICT;
CREATE TABLE editor (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  metadata_id INTEGER DEFAULT 1,
  orcid TEXT DEFAULT '',
  given TEXT NOT NULL,
  family TEXT NOT NULL,
  rorid TEXT DEFAULT '',
  organisation TEXT DEFAULT '',
  email TEXT DEFAULT '',
  url TEXT DEFAULT '',
  note TEXT DEFAULT ''
) STRICT;
CREATE TABLE creator (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  metadata_id INTEGER DEFAULT 1,
  orcid TEXT DEFAULT '',
  given TEXT NOT NULL,
  family TEXT NOT NULL,
  rorid TEXT DEFAULT '',
  organisation TEXT DEFAULT '',
  email TEXT DEFAULT '',
  url TEXT DEFAULT '',
  note TEXT DEFAULT ''
) STRICT;
CREATE TABLE publisher (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  metadata_id INTEGER DEFAULT 1,
  orcid TEXT DEFAULT '',
  given TEXT DEFAULT '',
  family TEXT DEFAULT '',
  rorid TEXT DEFAULT '',
  organisation TEXT DEFAULT '',
  email TEXT DEFAULT '',
  url TEXT DEFAULT '',
  note TEXT DEFAULT ''
) STRICT;
CREATE TABLE contributor (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  metadata_id INTEGER DEFAULT 1,
  orcid TEXT DEFAULT '',
  given TEXT NOT NULL,
  family TEXT NOT NULL,
  rorid TEXT DEFAULT '',
  organisation TEXT DEFAULT '',
  email TEXT DEFAULT '',
  url TEXT DEFAULT '',
  note TEXT DEFAULT ''
) STRICT;
CREATE TABLE source (
  id TEXT PRIMARY KEY,
  metadata_id INTEGER DEFAULT 1,
  type TEXT DEFAULT '',
  title TEXT DEFAULT '',
  authors TEXT DEFAULT '',
  issued TEXT DEFAULT '',
  isbn TEXT DEFAULT ''
) STRICT;
CREATE TABLE author (
  id TEXT PRIMARY KEY,
  source_id TEXT REFERENCES source DEFAULT '',
  alternative_id TEXT DEFAULT '', -- sep by ','
  given TEXT DEFAULT '',
  family TEXT NOT NULL,
  -- f. for filius,  Jr., etc
  suffix TEXT DEFAULT '',
  abbreviation_botany TEXT DEFAULT '',
  alternative_names TEXT DEFAULT '', -- separated by '|'
  sex_id TEXT REFERENCES sex DEFAULT '',
  country TEXT DEFAULT '',
  birth TEXT DEFAULT '',
  birth_place TEXT DEFAULT '',
  death TEXT DEFAULT '',
  affiliation TEXT DEFAULT '',
  interest TEXT DEFAULT '',
  reference_id TEXT DEFAULT '', -- sep by ','
  -- url
  link TEXT DEFAULT '',
  remarks TEXT DEFAULT '',
  modified TEXT DEFAULT '',
  modified_by TEXT DEFAULT ''
) STRICT;
CREATE TABLE reference (
  id TEXT PRIMARY KEY,
  alternative_id TEXT DEFAULT '', -- sep by ',', scope:id, id, URI/URN
  gn_local_id TEXT default '', -- used by GNverifier for links
  gn_global_id TEXT default '', -- used by GNverifier for links
  source_id TEXT REFERENCES source DEFAULT '',
  citation TEXT DEFAULT '',
  type TEXT REFERENCES reference_type DEFAULT '',
  -- author/s in format of either
  -- family1, given1; family2, given2; ..
  -- or
  -- given1 family1, given2 family2, ...
  author TEXT DEFAULT '',
  author_id TEXT DEFAULT '', -- 'ref' author, sep ','
  editor TEXT DEFAULT '', -- 'ref' author, sep ','
  editor_id TEXT DEFAULT '', -- 'ref' author, sep ','
  title TEXT DEFAULT '',
  title_short TEXT DEFAULT '',
  -- container_author is an author or a parent volume (book, journal) 
  container_author TEXT DEFAULT '',
  -- container_title of the parent container
  container_title TEXT DEFAULT '',
  -- container_title_short of the parent container
  container_title_short TEXT DEFAULT '',
  issued TEXT DEFAULT '', -- yyyy-mm-dd
  accessed TEXT DEFAULT '', -- yyyy-mm-dd
  -- collection_title of the parent volume
  collection_title TEXT DEFAULT '',
  -- collection_editor of the parent volume
  collection_editor TEXT DEFAULT '',
  volume TEXT DEFAULT '',
  issue TEXT DEFAULT '',
  -- edition number
  edition TEXT DEFAULT '',
  -- page number
  page TEXT DEFAULT '',
  publisher TEXT DEFAULT '',
  publisher_place TEXT DEFAULT '',
  -- version of the reference
  version TEXT DEFAULT '',
  isbn TEXT DEFAULT '',
  issn TEXT DEFAULT '',
  doi TEXT DEFAULT '',
  link TEXT DEFAULT '',
  remarks TEXT DEFAULT '',
  modified TEXT DEFAULT '',
  modified_by TEXT DEFAULT ''
) STRICT;
CREATE TABLE name (
  id TEXT PRIMARY KEY,
  alternative_id TEXT DEFAULT '',
  source_id TEXT DEFAULT '',
  -- basionym_id TEXT DEFAULT '', -- use name_relation instead
  gn_scientific_name_string TEXT NOT NULL, -- full name with authorship (if given)
  scientific_name TEXT NOT NULL, -- full canonical form
  authorship TEXT DEFAULT '', -- verbatim authorship
  rank_id TEXT REFERENCES rank DEFAULT '',
  uninomial TEXT DEFAULT '',
  genus TEXT DEFAULT '',
  infrageneric_epithet TEXT DEFAULT '',
  specific_epithet TEXT DEFAULT '',
  infraspecific_epithet TEXT DEFAULT '',
  cultivar_epithet TEXT DEFAULT '',
  notho_id TEXT DEFAULT '', -- ref name_part
  original_spelling INTEGER DEFAULT NULL, -- bool
  combination_authorship TEXT DEFAULT '', -- separated by '|'
  combination_authorship_id TEXT DEFAULT '', -- separated by '|'
  combination_ex_authorship TEXT DEFAULT '', -- separated by '|'
  combination_ex_authorship_id TEXT DEFAULT '', -- separated by '|'
  combination_authorship_year TEXT DEFAULT '',
  basionym_authorship TEXT DEFAULT '', -- separated by '|'
  basionym_authorship_id TEXT DEFAULT '', -- separated by '|'
  basionym_ex_authorship TEXT DEFAULT '', -- separated by '|'
  basionym_ex_authorship_id TEXT DEFAULT '', -- separated by '|'
  basionym_authorship_year TEXT DEFAULT '',
  code_id TEXT REFERENCES nom_code DEFAULT '',
  status_id TEXT REFERENCES nom_status DEFAULT '',
  reference_id TEXT DEFAULT '', -- refs about taxon sep ','
  published_in_year TEXT DEFAULT '',
  published_in_page TEXT DEFAULT '',
  published_in_page_link TEXT DEFAULT '',
  gender_id TEXT REFERENCES gender DEFAULT '',
  gender_agreement INTEGER DEFAULT NULL, -- bool
  etymology TEXT DEFAULT '',
  link TEXT DEFAULT '',
  remarks TEXT DEFAULT '',
  modified TEXT DEFAULT '',
  modified_by TEXT DEFAULT ''
) STRICT;
INSERT INTO name VALUES('T298','','','Heteroaulax adriatica Diesing','Heteroaulax adriatica','Diesing','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T001','','','Gymnodinium absumens Schiller','Gymnodinium absumens','Schiller','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T002','','','Gymnodinium achromaticum Lebour','Gymnodinium achromaticum','Lebour','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T297','','','Heteraulacus adriaticum Diesing','Heteraulacus adriaticum','Diesing','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T004','','','Gymnodinium aequatoriale Hasle','Gymnodinium aequatoriale','Hasle','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T003','','','Gymnodinium adriaticum (Schmarda) Kofoid & Swezy','Gymnodinium adriaticum','(Schmarda) Kofoid & Swezy','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T299','','','Peridinium adriaticum Schmarda','Peridinium adriaticum','Schmarda','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T006','','','Gymnodinium aesculum Baumeister','Gymnodinium aesculum','Baumeister','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T005','','','Gymnodinium aeruginosum Stein','Gymnodinium aeruginosum','Stein','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T007','','','Gymnodinium affine Dogiel','Gymnodinium affine','Dogiel','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T008','','','Gymnodinium agaricoides Campbell','Gymnodinium agaricoides','Campbell','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T301','','','Gymnodinium alaskense Bursa','Gymnodinium alaskense','Bursa','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T300','','','Gymnodinium agiliformis Schiller','Gymnodinium agiliformis','Schiller','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T011','','','Gymnodinium allophron Larsen','Gymnodinium allophron','Larsen','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T009','','','Gymnodinium agiliforme Schiller','Gymnodinium agiliforme','Schiller','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T010','','','Gymnodinium alaskensis Bursa','Gymnodinium alaskensis','Bursa','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T012','','','Gymnodinium amphiconicoides Schiller','Gymnodinium amphiconicoides','Schiller','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T013','','','Gymnodinium amphityphlum Larsen','Gymnodinium amphityphlum','Larsen','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T014','','','Gymnodinium amphora Kofoid & Swezy','Gymnodinium amphora','Kofoid & Swezy','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T015','','','Gymnodinium amplinucleum Campbell','Gymnodinium amplinucleum','Campbell','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T018','','','Gymnodinium arcuatum Kofoid','Gymnodinium arcuatum','Kofoid','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T017','','','Gymnodinium arcticum Wulff','Gymnodinium arcticum','Wulff','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T303','','','Gymnodinium arenicolum Dragesco','Gymnodinium arenicolum','Dragesco','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T020','','','Gymnodinium armoricanum Villeret','Gymnodinium armoricanum','Villeret','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T019','','','Gymnodinium arenicolus Dragesco','Gymnodinium arenicolus','Dragesco','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T016','','','Gymnodinium antarcticum (Balech) Thessen, Patterson & Murray','Gymnodinium antarcticum','(Balech) Thessen, Patterson & Murray','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T021','','','Gymnodinium atomatum Larsen','Gymnodinium atomatum','Larsen','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T302','','','Gymnodinium arenicola Dragesco','Gymnodinium arenicola','Dragesco','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T023','','','Gymnodinium aurantium Campbell','Gymnodinium aurantium','Campbell','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T022','','','Gymnodinium attenuatum Kofoid & Swezy','Gymnodinium attenuatum','Kofoid & Swezy','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T304','','','Gyrodinium aureolum Hulburt','Gyrodinium aureolum','Hulburt','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T025','','','Gymnodinium aureolum (Hulburt) Hansen','Gymnodinium aureolum','(Hulburt) Hansen','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T026','','','Gymnodinium aureum Kofoid & Swezy','Gymnodinium aureum','Kofoid & Swezy','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T024','','','Gymnodinium auratum Kofoid & Swezy','Gymnodinium auratum','Kofoid & Swezy','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T027','','','Gymnodinium australe Playfair','Gymnodinium australe','Playfair','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T306','','','Gymnodinium fuscum var. cornifax (Schilling) Playfair','Gymnodinium fuscum var. cornifax','(Schilling) Playfair','VARIETY','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T305','','','Gymnodinium australe var. acutum Playfair','Gymnodinium australe var. acutum','Playfair','VARIETY','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T029','','','Gymnodinium austriacum Schiller','Gymnodinium austriacum','Schiller','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T307','','','Gymnodinium autumnale Christen','Gymnodinium autumnale','Christen','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T028','','','Gymnodinium australense Ruinen','Gymnodinium australense','Ruinen','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T310','','','Gymnodinium titubans Christen','Gymnodinium titubans','Christen','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T309','','','Gymnodinium thompsonii (Thompson) Kiselev','Gymnodinium thompsonii','(Thompson) Kiselev','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T308','','','Gymnodinium cruciatum Thompson','Gymnodinium cruciatum','Thompson','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T313','','','Gymnodinium waltzi','Gymnodinium waltzi','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T311','','','Gymnodinium tituhans','Gymnodinium tituhans','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T312','','','Gymnodinium tridentatum Schiller','Gymnodinium tridentatum','Schiller','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T314','','','Gymnodinium waltzii Baumeister','Gymnodinium waltzii','Baumeister','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T030','','','Gymnodinium autumnale Skvortzov','Gymnodinium autumnale','Skvortzov','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T033','','','Gymnodinium baumeisteri Schiller','Gymnodinium baumeisteri','Schiller','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T032','','','Gymnodinium baicalense Antipova','Gymnodinium baicalense','Antipova','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T031','','','Gymnodinium baccatum Balech','Gymnodinium baccatum','Balech','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T034','','','Gymnodinium biciliatum Ohno','Gymnodinium biciliatum','Ohno','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T037','','','Gymnodinium bifurcatum Kofoid & Swezy','Gymnodinium bifurcatum','Kofoid & Swezy','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T035','','','Gymnodinium biconicum Schiller','Gymnodinium biconicum','Schiller','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T036','','','Gymnodinium bicorne Kofoid & Swezy','Gymnodinium bicorne','Kofoid & Swezy','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T039','','','Gymnodinium bisaetosum Lindemann','Gymnodinium bisaetosum','Lindemann','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T038','','','Gymnodinium birotundatum van Goor','Gymnodinium birotundatum','van Goor','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T040','','','Gymnodinium boguensis Campbell','Gymnodinium boguensis','Campbell','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T315','','','Gymnodinium boguense','Gymnodinium boguense','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T041','','','Gymnodinium bonaerense Akselman','Gymnodinium bonaerense','Akselman','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T042','','','Gymnodinium caerulescens Schiller','Gymnodinium caerulescens','Schiller','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T046','','','Gymnodinium caput Schiller','Gymnodinium caput','Schiller','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T316','','','Gymnodinium caesiei','Gymnodinium caesiei','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T043','','','Gymnodinium campbelli Popovsky','Gymnodinium campbelli','Popovsky','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T044','','','Gymnodinium canus Kofoid & Swezy','Gymnodinium canus','Kofoid & Swezy','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T047','','','Gymnodinium cassiei Norris','Gymnodinium cassiei','Norris','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T045','','','Gymnodinium capitatum Conrad & Kufferath','Gymnodinium capitatum','Conrad & Kufferath','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T048','','','Gymnodinium catenatum Graham','Gymnodinium catenatum','Graham','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T317','','','Gymnodinium catena','Gymnodinium catena','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T318','','','Gymnodinium catenata','Gymnodinium catenata','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T320','','','Dinastridium chiastosporum (Harris) Starmach','Dinastridium chiastosporum','(Harris) Starmach','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T049','','','Gymnodinium chiastosporum (Harris) Cridland','Gymnodinium chiastosporum','(Harris) Cridland','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T321','','','Dinastridium sexangulare Pascher','Dinastridium sexangulare','Pascher','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T323','','','Gymnodinium hippocastanum Cridland','Gymnodinium hippocastanum','Cridland','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T322','','','Gymnodinium chiastosporum Elbrachter & Schnepf','Gymnodinium chiastosporum','Elbrachter & Schnepf','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T324','','','Tetradinium chiastosporum Harris','Tetradinium chiastosporum','Harris','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T052','','','Gymnodinium cnecoides Harris','Gymnodinium cnecoides','Harris','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T050','','','Gymnodinium chukwanii Ballantine','Gymnodinium chukwanii','Ballantine','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T325','','','Gymnodinium saginatum Harris','Gymnodinium saginatum','Harris','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T051','','','Gymnodinium cinctum Kofoid & Swezy','Gymnodinium cinctum','Kofoid & Swezy','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T326','','','Gymnodinium luteofaba Javornický','Gymnodinium luteofaba','Javornický','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T327','','','Gymnodinium coerulatum','Gymnodinium coerulatum','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T053','','','Gymnodinium coeruleum Dogiel','Gymnodinium coeruleum','Dogiel','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T054','','','Gymnodinium colymbeticum Harris','Gymnodinium colymbeticum','Harris','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T055','','','Gymnodinium concavum Skvortzov','Gymnodinium concavum','Skvortzov','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T058','','','Gymnodinium corii Schiller','Gymnodinium corii','Schiller','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T056','','','Gymnodinium conicum Kofoid & Swezy','Gymnodinium conicum','Kofoid & Swezy','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T059','','','Gymnodinium corollarium Sundström, Kremp & Daugbjerg','Gymnodinium corollarium','Sundström, Kremp & Daugbjerg','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T328','','','Peridinium corpusculum Perty','Peridinium corpusculum','Perty','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T057','','','Gymnodinium contractum Kofoid & Swezy','Gymnodinium contractum','Kofoid & Swezy','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T060','','','Gymnodinium corpusculum (Perty) Saville-Kent','Gymnodinium corpusculum','(Perty) Saville-Kent','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T061','','','Gymnodinium costatum Kofoid & Swezy','Gymnodinium costatum','Kofoid & Swezy','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T063','','','Gymnodinium cucumis Schütt','Gymnodinium cucumis','Schütt','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T066','','','Gymnodinium danubiense Schiller','Gymnodinium danubiense','Schiller','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T329','','','Amphidinium cryophilum Wedemayer, Wilcox & Graham','Amphidinium cryophilum','Wedemayer, Wilcox & Graham','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T065','','','Gymnodinium danicans Campbell','Gymnodinium danicans','Campbell','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T064','','','Gymnodinium cyaneofungiforme Conrad & Kufferath','Gymnodinium cyaneofungiforme','Conrad & Kufferath','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T067','','','Gymnodinium deformabile Schiller','Gymnodinium deformabile','Schiller','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T068','','','Gymnodinium dentatum Larsen','Gymnodinium dentatum','Larsen','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T070','','','Gymnodinium diploconus Schütt','Gymnodinium diploconus','Schütt','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T071','','','Gymnodinium discoidale Harris','Gymnodinium discoidale','Harris','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T069','','','Gymnodinium devorans Schiller','Gymnodinium devorans','Schiller','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T062','','','Gymnodinium cryophilum (Wedemayer, Wilcox & Graham) Hansen & Moestrup','Gymnodinium cryophilum','(Wedemayer, Wilcox & Graham) Hansen & Moestrup','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T330','','','Glenodinium eurystomum Harris','Glenodinium eurystomum','Harris','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T331','','','Gymnodinium disoidale','Gymnodinium disoidale','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T332','','','Gymnodinium dogielii','Gymnodinium dogielii','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T075','','','Gymnodinium doma Kofoid & Swezy','Gymnodinium doma','Kofoid & Swezy','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T073','','','Gymnodinium dodgei Kofoid & Swezy','Gymnodinium dodgei','Kofoid & Swezy','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T074','','','Gymnodinium dogieli Kofoid & Swezy','Gymnodinium dogieli','Kofoid & Swezy','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T077','','','Gymnodinium endofasciculum Campbell','Gymnodinium endofasciculum','Campbell','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T078','','','Gymnodinium enorme Ballantine','Gymnodinium enorme','Ballantine','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T072','','','Gymnodinium dissimile Kofoid & Swezy','Gymnodinium dissimile','Kofoid & Swezy','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T333','','','Gymnodinium irregulare Conrad & Kufferath','Gymnodinium irregulare','Conrad & Kufferath','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T334','','','Gymnodinium excavata','Gymnodinium excavata','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T076','','','Gymnodinium dorsalisulcum (Hulburt, McLaughlin & Zahl) Murray, de Salas & Hallegraeff','Gymnodinium dorsalisulcum','(Hulburt, McLaughlin & Zahl) Murray, de Salas & Hallegraeff','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T081','','','Gymnodinium excavatum van Meel','Gymnodinium excavatum','van Meel','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T080','','','Gymnodinium eufrigidum Schiller','Gymnodinium eufrigidum','Schiller','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T079','','','Gymnodinium eucyaneum Hu, Yu & Zhang','Gymnodinium eucyaneum','Hu, Yu & Zhang','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T083','','','Gymnodinium filum Lebour','Gymnodinium filum','Lebour','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T082','','','Gymnodinium exechegloutum Norris','Gymnodinium exechegloutum','Norris','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T335','','','Peridinium fuscum Ehrenberg','Peridinium fuscum','Ehrenberg','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T085','','','Gymnodinium fossarum Conrad & Kufferath','Gymnodinium fossarum','Conrad & Kufferath','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T084','','','Gymnodinium flavum Kofoid & Swezy','Gymnodinium flavum','Kofoid & Swezy','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T336','','','Gymnodinium caudatum Prescott','Gymnodinium caudatum','Prescott','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T086','','','Gymnodinium fulgens Kofoid & Swezy','Gymnodinium fulgens','Kofoid & Swezy','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T087','','','Gymnodinium fuscum (Ehrenberg) Stein','Gymnodinium fuscum','(Ehrenberg) Stein','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T337','','','Gymnocystodinium gessneri Baumeister','Gymnocystodinium gessneri','Baumeister','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T089','','','Gymnodinium galeatum Larsen','Gymnodinium galeatum','Larsen','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T088','','','Gymnodinium galeaeforme Matzenauer','Gymnodinium galeaeforme','Matzenauer','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T339','','','Gymnodinium galaeforme','Gymnodinium galaeforme','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T338','','','Cystodinium gessneri (Baumeister) Bourelly','Cystodinium gessneri','(Baumeister) Bourelly','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T090','','','Gymnodinium galesianum Campbell','Gymnodinium galesianum','Campbell','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T092','','','Gymnodinium gibbera Schiller','Gymnodinium gibbera','Schiller','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T091','','','Gymnodinium gelbum Kofoid','Gymnodinium gelbum','Kofoid','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T096','','','Gymnodinium gracile Bergh','Gymnodinium gracile','Bergh','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T094','','','Gymnodinium glaucum Schiller','Gymnodinium glaucum','Schiller','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T095','','','Gymnodinium gleba Schütt','Gymnodinium gleba','Schütt','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T340','','','Gymnodinium abbreviatum splendens Lebour','Gymnodinium abbreviatum splendens','Lebour','SUBSPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T341','','','Gymnodinium lohmanni Paulsen','Gymnodinium lohmanni','Paulsen','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T093','','','Gymnodinium glandiforme Conrad & Kufferath','Gymnodinium glandiforme','Conrad & Kufferath','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T343','','','Gymnodinium spirale var. nobilis Pouchet','Gymnodinium spirale var. nobilis','Pouchet','VARIETY','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T342','','','Gymnodinium lohmannii Paulsen','Gymnodinium lohmannii','Paulsen','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T097','','','Gymnodinium gracilentum Campbell','Gymnodinium gracilentum','Campbell','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T098','','','Gymnodinium grammaticum (Pouchet) Kofoid & Swezy','Gymnodinium grammaticum','(Pouchet) Kofoid & Swezy','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T101','','','Gymnodinium guttula (Hada) Balech','Gymnodinium guttula','(Hada) Balech','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T345','','','Gymnodinium cinctum Hada','Gymnodinium cinctum','Hada','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T099','','','Gymnodinium granii Schiller','Gymnodinium granii','Schiller','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T344','','','Gymnodinium punctatum var. grammaticum Pouchet','Gymnodinium punctatum var. grammaticum','Pouchet','VARIETY','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T100','','','Gymnodinium guttiforme Larsen','Gymnodinium guttiforme','Larsen','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T102','','','Gymnodinium hamulus Kofoid & Swezy','Gymnodinium hamulus','Kofoid & Swezy','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T346','','','Gymnodinium spirale var. obtusum Dogiel','Gymnodinium spirale var. obtusum','Dogiel','VARIETY','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T103','','','Gymnodinium herbaceum Kofoid','Gymnodinium herbaceum','Kofoid','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T348','','','Katodinium intermedium Christen','Katodinium intermedium','Christen','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T105','','','Gymnodinium hiemale (Schiller) Popovsky','Gymnodinium hiemale','(Schiller) Popovsky','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T347','','','Katodinium hiemale (Schiller) Loeblich','Katodinium hiemale','(Schiller) Loeblich','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T104','','','Gymnodinium heterostriatum Kofoid & Swezy','Gymnodinium heterostriatum','Kofoid & Swezy','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T349','','','Gymnodinium hiroshimaense','Gymnodinium hiroshimaense','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T106','','','Gymnodinium hiroshimaensis Hada','Gymnodinium hiroshimaensis','Hada','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T350','','','Gymnodinium austriacum Huber-Pestalozzi','Gymnodinium austriacum','Huber-Pestalozzi','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T108','','','Gymnodinium hulburtii Campbell','Gymnodinium hulburtii','Campbell','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T107','','','Gymnodinium huber-pestalozzii Schiller','Gymnodinium huber-pestalozzii','Schiller','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T111','','','Gymnodinium incertum Herdman','Gymnodinium incertum','Herdman','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T109','','','Gymnodinium impatiens Skuja','Gymnodinium impatiens','Skuja','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T114','','','Gymnodinium inconstans van Meel','Gymnodinium inconstans','van Meel','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T112','','','Gymnodinium incisum Kofoid & Swezy','Gymnodinium incisum','Kofoid & Swezy','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T110','','','Gymnodinium impudicum (Fraga & Bravo) Hansen & Moestrup','Gymnodinium impudicum','(Fraga & Bravo) Hansen & Moestrup','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T115','','','Gymnodinium indicum Shyam & Sarma','Gymnodinium indicum','Shyam & Sarma','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T116','','','Gymnodinium inerme (Schmarda) Saville-Kent','Gymnodinium inerme','(Schmarda) Saville-Kent','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T113','','','Gymnodinium incoloratum Conrad & Kufferath','Gymnodinium incoloratum','Conrad & Kufferath','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T351','','','Gymnodinium intercalare','Gymnodinium intercalare','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T118','','','Gymnodinium intercalaris Bursa','Gymnodinium intercalaris','Bursa','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T117','','','Gymnodinium instriatum (Freudenthal & Lee) Coats','Gymnodinium instriatum','(Freudenthal & Lee) Coats','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T120','','','Gymnodinium japonicum Hada','Gymnodinium japonicum','Hada','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T352','','','Gymnodinium japonica','Gymnodinium japonica','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T119','','','Gymnodinium irregulare Hope','Gymnodinium irregulare','Hope','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T353','','','Gymnodinium japonica var. throndseni Konovalova','Gymnodinium japonica var. throndseni','Konovalova','VARIETY','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T121','','','Gymnodinium katodiniforme Elbrächter & Schnepf','Gymnodinium katodiniforme','Elbrächter & Schnepf','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T354','','','Hypnodinium sphaericum Klebs','Hypnodinium sphaericum','Klebs','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T122','','','Gymnodinium knollii Schiller','Gymnodinium knollii','Schiller','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T355','','','Gymnodinium koyalevskii','Gymnodinium koyalevskii','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T296','','','Gymnodinium klebsi Lindemann','Gymnodinium klebsi','Lindemann','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T123','','','Gymnodinium kowalevskii Pitzik','Gymnodinium kowalevskii','Pitzik','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T124','','','Gymnodinium kujavense Liebetanz','Gymnodinium kujavense','Liebetanz','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T125','','','Gymnodinium lachmanni Saville-Kent','Gymnodinium lachmanni','Saville-Kent','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T127','','','Gymnodinium lacustre Schiller','Gymnodinium lacustre','Schiller','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T356','','','Gymnodinium limneticum Lackey','Gymnodinium limneticum','Lackey','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T357','','','Gymnodinium profundum Schiller','Gymnodinium profundum','Schiller','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T126','','','Gymnodinium lackeyi (Lackey) Kiselev','Gymnodinium lackeyi','(Lackey) Kiselev','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T129','','','Gymnodinium lanskoi Rouchijanen','Gymnodinium lanskoi','Rouchijanen','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T359','','','Glenodinium minimum (Lantzsch) Bachmann','Glenodinium minimum','(Lantzsch) Bachmann','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T128','','','Gymnodinium lalitae Sarma & Shyam','Gymnodinium lalitae','Sarma & Shyam','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T358','','','Gymnodinium minimum Lantzsch','Gymnodinium minimum','Lantzsch','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T130','','','Gymnodinium lantzschii Utermöhl','Gymnodinium lantzschii','Utermöhl','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T131','','','Gymnodinium latum Skuja','Gymnodinium latum','Skuja','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T134','','','Gymnodinium leptum Norris','Gymnodinium leptum','Norris','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T133','','','Gymnodinium legiconveniens Schiller','Gymnodinium legiconveniens','Schiller','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T132','','','Gymnodinium lazulum Hulburt','Gymnodinium lazulum','Hulburt','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T135','','','Gymnodinium limitatum Skuja','Gymnodinium limitatum','Skuja','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T137','','','Gymnodinium lineopunicum Kofoid & Swezy','Gymnodinium lineopunicum','Kofoid & Swezy','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T136','','','Gymnodinium lineatum Kofoid & Swezy','Gymnodinium lineatum','Kofoid & Swezy','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T140','','','Gymnodinium lobularis Campbell','Gymnodinium lobularis','Campbell','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T138','','','Gymnodinium lira Kofoid & Swezy','Gymnodinium lira','Kofoid & Swezy','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T139','','','Gymnodinium litoralis Reñé','Gymnodinium litoralis','Reñé','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T141','','','Gymnodinium lucidum Ballantine','Gymnodinium lucidum','Ballantine','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T144','','','Gymnodinium autumnale Christen','Gymnodinium autumnale','Christen','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T142','','','Gymnodinium campaniforme Popovsky','Gymnodinium campaniforme','Popovsky','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T146','','','Gymnodinium titubens','Gymnodinium titubens','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T145','','','Gymnodinium tridentatum Schiller','Gymnodinium tridentatum','Schiller','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T143','','','Gymnodinium viride Penard','Gymnodinium viride','Penard','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T147','','','Gymnodinium cruciatum Thompson','Gymnodinium cruciatum','Thompson','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T148','','','Gymnodinium translucens Campbell','Gymnodinium translucens','Campbell','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T149','','','Gymnodinium saginatum Harris','Gymnodinium saginatum','Harris','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T153','','','Gymnodinium roseum Lohmann','Gymnodinium roseum','Lohmann','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T150','','','Gymnodinium pulvisulcus Klebs','Gymnodinium pulvisulcus','Klebs','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T151','','','Gymnodinium viridis Lebour','Gymnodinium viridis','Lebour','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T155','','','Gymnodinium sp. Hada','Gymnodinium sp.','Hada','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T154','','','Massartia hiemalis Schiller','Massartia hiemalis','Schiller','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T152','','','Gymnodinium abbreviatum Kofoid & Swezy','Gymnodinium abbreviatum','Kofoid & Swezy','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T156','','','Gyrodinium impudicum Fraga & Bravo','Gyrodinium impudicum','Fraga & Bravo','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T157','','','Peridinium inerme Schmarda','Peridinium inerme','Schmarda','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T161','','','Gymnodinium Stein','Gymnodinium','Stein','GENUS','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T160','','','Gymnodinium hyalinum Lebour','Gymnodinium hyalinum','Lebour','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T159','','','Gymnodinium albulum Lindemann','Gymnodinium albulum','Lindemann','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T164','','','Tetrodinium chiastosporum','Tetrodinium chiastosporum','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T158','','','Gyrodinium instriatum Freudenthal & Lee','Gyrodinium instriatum','Freudenthal & Lee','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T167','','','Gymnodinium lunula Schütt','Gymnodinium lunula','Schütt','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T165','','','Gymnodinium hippocastanum Cridland','Gymnodinium hippocastanum','Cridland','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T170','','','Dissodinium lunula Pascher','Dissodinium lunula','Pascher','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T168','','','Pyrocystis lunula Schütt','Pyrocystis lunula','Schütt','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T169','','','Diplodinium lunula Klebs','Diplodinium lunula','Klebs','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T171','','','Gymnodinium maguelonnense Biecheler','Gymnodinium maguelonnense','Biecheler','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T172','','','Gymnodinium marinum Saville-Kent','Gymnodinium marinum','Saville-Kent','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T166','','','Katodinium dorsalisulcum Hulbert, McLaughlin & Zahl','Katodinium dorsalisulcum','Hulbert, McLaughlin & Zahl','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T176','','','Gymnodinium minor Lebour','Gymnodinium minor','Lebour','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T174','','','Gymnodinium meervalli Redeke','Gymnodinium meervalli','Redeke','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T173','','','Gymnodinium marylandicum Thompson','Gymnodinium marylandicum','Thompson','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T175','','','Gymnodinium microreticulatum Bolch & Hallegraeff','Gymnodinium microreticulatum','Bolch & Hallegraeff','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T177','','','Gymnodinium minutulum Larsen','Gymnodinium minutulum','Larsen','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T178','','','Gymnodinium mitratum Schiller','Gymnodinium mitratum','Schiller','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T179','','','Gymnodinium modestum Balech','Gymnodinium modestum','Balech','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T180','','','Gymnodinium multilineatum Kofoid & Swezy','Gymnodinium multilineatum','Kofoid & Swezy','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T183','','','Gymnodinium najadeum Schiller','Gymnodinium najadeum','Schiller','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T181','','','Gymnodinium multistriatum Kofoid & Swezy','Gymnodinium multistriatum','Kofoid & Swezy','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T184','','','Gymnodinium nanum Schiller','Gymnodinium nanum','Schiller','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T185','','','Gymnodinium neapolitanum Schiller','Gymnodinium neapolitanum','Schiller','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T187','','','Gymnodinium oceanicum Hasle','Gymnodinium oceanicum','Hasle','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T186','','','Gymnodinium nolleri Ellegaard & Moestrup','Gymnodinium nolleri','Ellegaard & Moestrup','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T182','','','Gymnodinium myriopyrenoides Yamaguchi, Nakayama, Kai & Inouye','Gymnodinium myriopyrenoides','Yamaguchi, Nakayama, Kai & Inouye','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T188','','','Gymnodinium ochraceum Kofoid','Gymnodinium ochraceum','Kofoid','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T189','','','Gymnodinium octo Larsen','Gymnodinium octo','Larsen','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T190','','','Gymnodinium olivaceum Skvortzov','Gymnodinium olivaceum','Skvortzov','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T193','','','Gymnodinium pachydermatum Kofoid & Swezy','Gymnodinium pachydermatum','Kofoid & Swezy','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T191','','','Gymnodinium ostenfeldi Schiller','Gymnodinium ostenfeldi','Schiller','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T194','','','Gymnodinium pallidum Skuja','Gymnodinium pallidum','Skuja','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T196','','','Gymnodinium paradoxiforme Schiller','Gymnodinium paradoxiforme','Schiller','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T192','','','Gymnodinium ovulum Kofoid & Swezy','Gymnodinium ovulum','Kofoid & Swezy','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T195','','','Gymnodinium palustriforme Hansen & Flaim','Gymnodinium palustriforme','Hansen & Flaim','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T199','','','Gymnodinium parvum Larsen','Gymnodinium parvum','Larsen','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T197','','','Gymnodinium paradoxum Schilling','Gymnodinium paradoxum','Schilling','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T198','','','Gymnodinium paradoxum var. major Lemmermann','Gymnodinium paradoxum var. major','Lemmermann','VARIETY','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T200','','','Gymnodinium patagonicum Balech','Gymnodinium patagonicum','Balech','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T202','','','Gymnodinium pavlae Popovsky','Gymnodinium pavlae','Popovsky','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T201','','','Gymnodinium paulseni Schiller','Gymnodinium paulseni','Schiller','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T203','','','Gymnodinium peisonis Schiller','Gymnodinium peisonis','Schiller','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T204','','','Gymnodinium perplexum van Meel','Gymnodinium perplexum','van Meel','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T205','','','Gymnodinium placidum Herdman','Gymnodinium placidum','Herdman','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T206','','','Gymnodinium polycomma Larsen','Gymnodinium polycomma','Larsen','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T208','','','Gymnodinium prolatum Larsen','Gymnodinium prolatum','Larsen','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T207','','','Gymnodinium posthiemale Schiller','Gymnodinium posthiemale','Schiller','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T210','','','Gymnodinium pulchrum Schiller','Gymnodinium pulchrum','Schiller','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T209','','','Gymnodinium pseudomirabile Hansen & Flaim','Gymnodinium pseudomirabile','Hansen & Flaim','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T211','','','Gymnodinium pumilum Larsen','Gymnodinium pumilum','Larsen','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T212','','','Gymnodinium punctatum Pouchet','Gymnodinium punctatum','Pouchet','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T214','','','Gymnodinium purpureum Skuja','Gymnodinium purpureum','Skuja','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T215','','','Gymnodinium pygmaeum Lebour','Gymnodinium pygmaeum','Lebour','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T216','','','Gymnodinium pyrocystis Jörgensen','Gymnodinium pyrocystis','Jörgensen','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T213','','','Gymnodinium puniceum Kofoid & Swezy','Gymnodinium puniceum','Kofoid & Swezy','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T217','','','Gymnodinium radiatum Kofoid & Swezy','Gymnodinium radiatum','Kofoid & Swezy','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T220','','','Gymnodinium rhomboides Schütt','Gymnodinium rhomboides','Schütt','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T219','','','Gymnodinium regulare van Meel','Gymnodinium regulare','van Meel','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T218','','','Gymnodinium ravenescens Kofoid & Swezy','Gymnodinium ravenescens','Kofoid & Swezy','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T224','','','Gymnodinium roseolum (Schmarda) Stein','Gymnodinium roseolum','(Schmarda) Stein','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T225','','','Glenodinium roseolum Schmarda','Glenodinium roseolum','Schmarda','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T226','','','Gymnodinium roseostigma Campbell','Gymnodinium roseostigma','Campbell','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T228','','','Gymnodinium rubrocinctum Lebour','Gymnodinium rubrocinctum','Lebour','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T229','','','Gymnodinium schaefferi Morris','Gymnodinium schaefferi','Morris','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T227','','','Gymnodinium rubricauda Kofoid & Swezy','Gymnodinium rubricauda','Kofoid & Swezy','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T234','','','Gymnodinium soyai Hada','Gymnodinium soyai','Hada','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T233','','','Gymnodinium situla Kofoid & Swezy','Gymnodinium situla','Kofoid & Swezy','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T232','','','Gymnodinium semidivisum Schiller','Gymnodinium semidivisum','Schiller','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T231','','','Gymnodinium scopulosum Kofoid & Swezy','Gymnodinium scopulosum','Kofoid & Swezy','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T230','','','Gymnodinium schuettii Schiller','Gymnodinium schuettii','Schiller','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T236','','','Gymnodinium gracile var. sphaerica Calkins','Gymnodinium gracile var. sphaerica','Calkins','VARIETY','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T237','','','Gymnodinium sphaeroideum Kofoid','Gymnodinium sphaeroideum','Kofoid','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T238','','','Gymnodinium stellatum Hulburt','Gymnodinium stellatum','Hulburt','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T235','','','Gymnodinium sphaericum (Calkins) Kofoid & Swezy','Gymnodinium sphaericum','(Calkins) Kofoid & Swezy','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T241','','','Gymnodinium submontanum Schiller','Gymnodinium submontanum','Schiller','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T239','','','Cystodinium steinii Klebs','Cystodinium steinii','Klebs','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T360','','','Gymnodinium albulum Lindemann','Gymnodinium albulum','Lindemann','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T240','','','Gymnodinium steini (Klebs) Lindemann','Gymnodinium steini','(Klebs) Lindemann','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T243','','','Gymnodinium subrufescens Martin','Gymnodinium subrufescens','Martin','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T242','','','Gymnodinium subroseum Campbell','Gymnodinium subroseum','Campbell','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T245','','','Gymnodinium terrum Baumeister','Gymnodinium terrum','Baumeister','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T361','','','Gymnodinium thomasii','Gymnodinium thomasii','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T244','','','Gymnodinium sulcatum Kofoid & Swezy','Gymnodinium sulcatum','Kofoid & Swezy','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T246','','','Gymnodinium thomasi Christen','Gymnodinium thomasi','Christen','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T247','','','Gymnodinium tintinnicola Lohmann','Gymnodinium tintinnicola','Lohmann','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T249','','','Gymnodinium trapeziforme Attaran-Fariman & Bolch','Gymnodinium trapeziforme','Attaran-Fariman & Bolch','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T251','','','Gymnodinium impar Harris','Gymnodinium impar','Harris','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T248','','','Gymnodinium translucens Kofoid & Swezy','Gymnodinium translucens','Kofoid & Swezy','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T250','','','Gymnodinium triceratium Skuja','Gymnodinium triceratium','Skuja','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T362','','','Gymnodinium asymmetricum Woloszynska','Gymnodinium asymmetricum','Woloszynska','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T253','','','Peridinium uberrima Allman','Peridinium uberrima','Allman','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T254','','','Gymnodinium mirabile var. rufescens Penard','Gymnodinium mirabile var. rufescens','Penard','VARIETY','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T365','','','Gymnodinium irregulare Christen','Gymnodinium irregulare','Christen','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T363','','','Glenodinium uberrimum Schilling','Glenodinium uberrimum','Schilling','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T252','','','Gymnodinium uberrimum (Allman) Kofoid & Swezy','Gymnodinium uberrimum','(Allman) Kofoid & Swezy','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T364','','','Gymnodinium bogoriense Klebs','Gymnodinium bogoriense','Klebs','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T366','','','Gymnodinium obesum Schiller','Gymnodinium obesum','Schiller','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T367','','','Gymnodinium poculiferum Skuja','Gymnodinium poculiferum','Skuja','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T370','','','Gymnodinium uberrimum var. rotundatum Popovsky','Gymnodinium uberrimum var. rotundatum','Popovsky','VARIETY','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T369','','','Gymnodinium rufescens Lemmermann','Gymnodinium rufescens','Lemmermann','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T368','','','Gymnodinium rotundatum Klebs','Gymnodinium rotundatum','Klebs','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T371','','','Gyrodinium traunsteineri Lindemann','Gyrodinium traunsteineri','Lindemann','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T373','','','Gymnodinium ubberimum','Gymnodinium ubberimum','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T372','','','Melodinium uberrimum Saville-Kent','Melodinium uberrimum','Saville-Kent','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T255','','','Gymnodinium uncatenum (Hulburt) Hallegraeff','Gymnodinium uncatenum','(Hulburt) Hallegraeff','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T259','','','Gymnodinium varians Maskell','Gymnodinium varians','Maskell','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T256','','','Gyrodinium uncatenum','Gyrodinium uncatenum','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T260','','','Gymnodinium minimum Klebs','Gymnodinium minimum','Klebs','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T257','','','Gymnodinium valdecompressum Campbell','Gymnodinium valdecompressum','Campbell','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T258','','','Gymnodinium variabile Herdman','Gymnodinium variabile','Herdman','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T262','','','Amphidinium pellucidum Herdman','Amphidinium pellucidum','Herdman','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T261','','','Gymnodinium venator Flø Jørgensen & Murray','Gymnodinium venator','Flø Jørgensen & Murray','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T375','','','Amphidinium subsalsum Biecheler','Amphidinium subsalsum','Biecheler','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T263','','','Gymnodinium verruculosum Campbell','Gymnodinium verruculosum','Campbell','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T374','','','Gymnodinium pellucidum (Herdman) Flø Jørgensen & Murray','Gymnodinium pellucidum','(Herdman) Flø Jørgensen & Murray','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T264','','','Gymnodinium vestifici Schütt','Gymnodinium vestifici','Schütt','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T376','','','Gymnodinium vestificii','Gymnodinium vestificii','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T266','','','Gymnodinium viridaliut Schiller','Gymnodinium viridaliut','Schiller','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T267','','','Gymnodinium viridans van Meel','Gymnodinium viridans','van Meel','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T270','','','Gymnodinium wawrikae Schiller','Gymnodinium wawrikae','Schiller','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T265','','','Gymnodinium violescens Kofoid & Swezy','Gymnodinium violescens','Kofoid & Swezy','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T271','','','Gymnodinium wilczeki Pouchet','Gymnodinium wilczeki','Pouchet','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T268','','','Gymnodinium viridescens Kofoid','Gymnodinium viridescens','Kofoid','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T269','','','Gymnodinium voukii Schiller','Gymnodinium voukii','Schiller','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T272','','','Gymnodinium wulffii Schiller','Gymnodinium wulffii','Schiller','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T377','','','Gymnodinium wulffi','Gymnodinium wulffi','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T378','','','Gymnodinium wulfii','Gymnodinium wulfii','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T274','','','Gymnodinium palustre Zacharias','Gymnodinium palustre','Zacharias','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T379','','','Gymnodinium zachariasii','Gymnodinium zachariasii','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T276','','','Dubosquella','Dubosquella','','GENUS','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T273','','','Gymnodinium zachariasi Lemmermann','Gymnodinium zachariasi','Lemmermann','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T278','','','Nusuttodinium Takano & Horiguchi','Nusuttodinium','Takano & Horiguchi','GENUS','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T277','','','Dubosquella tintinnicola','Dubosquella tintinnicola','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T275','','','Gymnodinium smaydae Kang, Jeong & Moestrup','Gymnodinium smaydae','Kang, Jeong & Moestrup','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T281','','','Gymnodinium acidotum Nygaard','Gymnodinium acidotum','Nygaard','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T284','','','Gymnodinium p.dorhni Wawrik','Gymnodinium p.dorhni','Wawrik','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T280','','','Nusuttodinium acidotum (Nygaard) Takano & Horiguchi','Nusuttodinium acidotum','(Nygaard) Takano & Horiguchi','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T286','','','Dubosquellidae','Dubosquellidae','','FAMILY','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T285','','','Gymnodiniaceae Lankester','Gymnodiniaceae','Lankester','FAMILY','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T282','','','Nusuttodinium aeruginosum (Stein) Takano & Horiguchi','Nusuttodinium aeruginosum','(Stein) Takano & Horiguchi','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T289','','','Gymnodinium inusitatum Gu','Gymnodinium inusitatum','Gu','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T283','','','Nusuttodinium myriopyrenoides (Yamaguchi, Nakayama, Kai & Inouye) Takano & Yamaguchi','Nusuttodinium myriopyrenoides','(Yamaguchi, Nakayama, Kai & Inouye) Takano & Yamaguchi','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T223','','','Gymnodinium accuminatum','Gymnodinium accuminatum','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T290','','','Gymnodinium palustre (Schilling) Wołoszyńska','Gymnodinium palustre','(Schilling) Wołoszyńska','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T287','','','Levanderina fissa (Levander) Moestrup, Hakanen, Hansen, Daugbjerg & Ellegaard','Levanderina fissa','(Levander) Moestrup, Hakanen, Hansen, Daugbjerg & Ellegaard','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T291','','','Biecheleria pseudopalustris (Schiller) Moestrup, Lindberg & Daugbjerg','Biecheleria pseudopalustris','(Schiller) Moestrup, Lindberg & Daugbjerg','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T288','','','Levanderina Moestrup, Hakanen, Hansen, Daugbjerg & Ellegaard','Levanderina','Moestrup, Hakanen, Hansen, Daugbjerg & Ellegaard','GENUS','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T292','','','Biecheleria Moestrup, Lindberg & Daugbjerg','Biecheleria','Moestrup, Lindberg & Daugbjerg','GENUS','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T293','','','Spiniferodinium Horguchi & Chihara','Spiniferodinium','Horguchi & Chihara','GENUS','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T294','','','Spiniferodinium palustre (Schilling) Kretschmann & Gottschling','Spiniferodinium palustre','(Schilling) Kretschmann & Gottschling','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T295','','','Gymnodinium palustre Schilling','Gymnodinium palustre','Schilling','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T380','','','Gymnodinium albertii Vozzhennikova','Gymnodinium albertii','Vozzhennikova','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T381','','','Gymnodinium attedalense Cookson & Eisenack','Gymnodinium attedalense','Cookson & Eisenack','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T383','','','Gymnodinium australiense Deflandre & Cookson','Gymnodinium australiense','Deflandre & Cookson','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T385','','','Gymnodinium avellana Lejeune-Carpentier','Gymnodinium avellana','Lejeune-Carpentier','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T384','','','Apteodinium australiense (Deflandre & Cookson) Williams','Apteodinium australiense','(Deflandre & Cookson) Williams','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T382','','','Endoscrinium attadalense (Cookson & Eisenack) Riding & Fensome','Endoscrinium attadalense','(Cookson & Eisenack) Riding & Fensome','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T387','','','Gymnodinium cretaceum Deflandre','Gymnodinium cretaceum','Deflandre','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T389','','','Gymnodinium cretaceum var. undulacostata Boltenhagen','Gymnodinium cretaceum var. undulacostata','Boltenhagen','VARIETY','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T386','','','Dinogymnium avellana (Lejeune-Carpentier) Evitt, Clarke & Verdier','Dinogymnium avellana','(Lejeune-Carpentier) Evitt, Clarke & Verdier','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T391','','','Gymnodinium curvatum Vozzhennikova','Gymnodinium curvatum','Vozzhennikova','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T390','','','Dinogymnium cretaceum var. undulacostata','Dinogymnium cretaceum var. undulacostata','','VARIETY','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T388','','','Dinogymnium cretaceum (Deflandre) Evitt, Clarke & Verdier','Dinogymnium cretaceum','(Deflandre) Evitt, Clarke & Verdier','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T392','','','Gymnodinium dabendorfense Alberti','Gymnodinium dabendorfense','Alberti','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T396','','','Gymnodinium denticulatum Alberti','Gymnodinium denticulatum','Alberti','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T394','','','Gymnodinium decorum Deflandre','Gymnodinium decorum','Deflandre','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T393','','','Luxadinium dabendorfense (Alberti) Bujak & Davies','Luxadinium dabendorfense','(Alberti) Bujak & Davies','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T395','','','Dinogymnium decorum (Deflandre) Evitt, Clarke & Verdier','Dinogymnium decorum','(Deflandre) Evitt, Clarke & Verdier','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T398','','','Gymnodinium digitus Deflandre','Gymnodinium digitus ','Deflandre','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T400','','','Gymnodinium digitus var. crassus Vozzhennikova','Gymnodinium digitus var. crassus ','Vozzhennikova','VARIETY','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T401','','','Gymnodinium fehmarnense Morgenroth','Gymnodinium fehmarnense','Morgenroth','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T399','','','Dinogymnium digitus (Deflandre) Evitt, Clarke & Verdier','Dinogymnium digitus','(Deflandre) Evitt, Clarke & Verdier','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T397','','','Dinogymnium denticulatum (Alberti) Evitt, Clarke & Verdier','Dinogymnium denticulatum','(Alberti) Evitt, Clarke & Verdier','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T403','','','Gymnodinium galeritum Deflandre','Gymnodinium galeritum','Deflandre','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T402','','','Gymnodinium gabonense Deflandre','Gymnodinium gabonense ','Deflandre','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T404','','','Endoscrinium galeritum (Deflandre) Vozzhennikova','Endoscrinium galeritum','(Deflandre) Vozzhennikova','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T405','','','Gymnodinium heterocostatum Deflandre','Gymnodinium heterocostatum','Deflandre','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T408','','','Gymnodinium hexagonum Deflandre-Rigaud','Gymnodinium hexagonum','Deflandre-Rigaud','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T410','','','Gymnodinium hyalinum Vozzhennikova','Gymnodinium hyalinum','Vozzhennikova','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T407','','','Gymnodinium heterocostatum var. kolpaschevi Vozzhennikova','Gymnodinium heterocostatum var. kolpaschevi','Vozzhennikova','VARIETY','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T409','','','Dinogymnium hexagonum (Deflandre-Rigaud) Evitt, Clarke & Verdier','Dinogymnium hexagonum','(Deflandre-Rigaud) Evitt, Clarke & Verdier','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T411','','','Gymnodinium kasachstanicum Vozzhennikova','Gymnodinium kasachstanicum','Vozzhennikova','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T406','','','Dinogymnium heterocostatum (Deflandre) Evitt, Clarke & Verdier','Dinogymnium heterocostatum','(Deflandre) Evitt, Clarke & Verdier','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T414','','','Gymnodinium longicorne Vozzhennikova','Gymnodinium longicorne','Vozzhennikova','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T412','','','Gymnodinium laticinctum Deflandre','Gymnodinium laticinctum','Deflandre','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T415','','','Gymnodinium longicornis Vozzhennikova','Gymnodinium longicornis','Vozzhennikova','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T416','','','Gymnodinium marthae Deflandre','Gymnodinium marthae','Deflandre','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T413','','','Dinogymnium laticinctum (Deflandre) Evitt, Clarke & Verdier','Dinogymnium laticinctum','(Deflandre) Evitt, Clarke & Verdier','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T419','','','Gymnodinium nelsonense Cookson','Gymnodinium nelsonense','Cookson','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T418','','','Gymnodinium muticum Vozzhennikova','Gymnodinium muticum','Vozzhennikova','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T417','','','Dinogymnium marthae (Deflandre) Evitt, Clarke & Verdier','Dinogymnium marthae','(Deflandre) Evitt, Clarke & Verdier','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T421','','','Gymnodinium parvimarginatum Cookson & Eisenack','Gymnodinium parvimarginatum','Cookson & Eisenack','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T424','','','Gymnodinium pontis-mariae Deflandre','Gymnodinium pontis-mariae','Deflandre','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T422','','','Scriniodinium parvimarginatum (Cookson & Eisenack) Eisenack','Scriniodinium parvimarginatum','(Cookson & Eisenack) Eisenack','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T423','','','Gymnodinium pontismariae Deflandre','Gymnodinium pontismariae','Deflandre','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T420','','','Dinogymnium nelsonense (Cookson) Evitt, Clarke & Verdier','Dinogymnium nelsonense','(Cookson) Evitt, Clarke & Verdier','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T425','','','Gymnodinium sibiricum Vozzhennikova','Gymnodinium sibiricum','Vozzhennikova','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T428','','','Gymnodinium strombomorphum Deflandre','Gymnodinium strombomorphum','Deflandre','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T430','','','Gymnodinium torulosum Deflandre','Gymnodinium torulosum','Deflandre','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T426','','','Gymnodinium sphaerocephalum var. laevis Vozzhennikova','Gymnodinium sphaerocephalum var. laevis','Vozzhennikova','VARIETY','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T427','','','Gymnodinium sphaerocephalum Vozzhennikova','Gymnodinium sphaerocephalum','Vozzhennikova','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T429','','','Dinogymnium strombomorphum (Deflandre) Evitt, Clarke & Verdier','Dinogymnium strombomorphum','(Deflandre) Evitt, Clarke & Verdier','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T431','','','Gymnodinium ventriosum Alberti','Gymnodinium ventriosum','Alberti','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T435','','','Gymnodinium acrotrochum','Gymnodinium acrotrochum','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T434','','','Gyrodinium acrotrochum Larsen','Gyrodinium acrotrochum','Larsen','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T437','','','Gymnodinium acuminatum Christen','Gymnodinium acuminatum','Christen','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T436','','','Gyrodinium Kofoid & Swezy','Gyrodinium','Kofoid & Swezy','GENUS','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T438','','','Gymnodinium acutissimum Okolodkov','Gymnodinium acutissimum','Okolodkov','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T433','','','Dinogymnium westralium (Cookson & Eisenack) Evitt, Clarke & Verdier','Dinogymnium westralium','(Cookson & Eisenack) Evitt, Clarke & Verdier','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T432','','','Gymnodinium westralium Cookson & Eisenack','Gymnodinium westralium','Cookson & Eisenack','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T439','','','Herdmania litoralis Dodge','Herdmania litoralis','Dodge','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T442','','','Gymnodinium agilis','Gymnodinium agilis','','UNRANKED','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T441','','','Herdmania Dodge','Herdmania','Dodge','GENUS','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T440','','','Gymnodinium agile Herdman','Gymnodinium agile','Herdman','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T446','','','Gymnodinium alba','Gymnodinium alba','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T445','','','Peridiniopsis Lemmermann','Peridiniopsis','Lemmermann','GENUS','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T443','','','Peridiniopsis berolinense (Lemmermann) Bourrelly','Peridiniopsis berolinense','(Lemmermann) Bourrelly','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T448','','','Gymnodinium albidum Lackey & Lackey','Gymnodinium albidum','Lackey & Lackey','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T444','','','Gymnodinium alatum Litvienko','Gymnodinium alatum','Litvienko','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T449','','','Amphidinium amphidinioides (Geitler) Schiller','Amphidinium amphidinioides','(Geitler) Schiller','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T447','','','Gymnodinium albida Lackey & Lackey','Gymnodinium albida','Lackey & Lackey','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T450','','','Gymnodinium amphidinioides Geitler','Gymnodinium amphidinioides','Geitler','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T451','','','Nusuttodinium amphidinioides (Geitler) Takano & Horiguchi','Nusuttodinium amphidinioides','(Geitler) Takano & Horiguchi','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T455','','','Gymnodinium astigmatica Christen','Gymnodinium astigmatica','Christen','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T453','','','Gymnodinium archimedes Pouchet','Gymnodinium archimedes','Pouchet','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T454','','','Gymnodinium archimedis','Gymnodinium archimedis','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T452','','','Cochlodinium archimedes (Pouchet) Lemmermann','Cochlodinium archimedes','(Pouchet) Lemmermann','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T459','','','Gymnodinium bei','Gymnodinium bei','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T456','','','Gymnodinium asymmetricum Massart','Gymnodinium asymmetricum','Massart','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T460','','','Gymnodinium béii Spero','Gymnodinium béii','Spero','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T457','','','Katodinium asymmetricum (Massart) Loeblich','Katodinium asymmetricum','(Massart) Loeblich','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T462','','','Gymnodinium bicaudatum Pavillard','Gymnodinium bicaudatum','Pavillard','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T458','','','Pelagodinium béii (Spero) Siano, Montresor, Probert & Vargas','Pelagodinium béii','(Spero) Siano, Montresor, Probert & Vargas','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T463','','','Cystodinium bisetosum (Lindemann) Huber-Pestalozzi','Cystodinium bisetosum','(Lindemann) Huber-Pestalozzi','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T464','','','Gymnodinium bisetosum Lindemann','Gymnodinium bisetosum','Lindemann','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T466','','','Gymnodinium blax Harris','Gymnodinium blax','Harris','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T465','','','Katodinium fungiforme (Anissimova) Loeblich','Katodinium fungiforme','(Anissimova) Loeblich','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T471','','','Gymnodinium brene','Gymnodinium brene','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T468','','','Gymnodinium bohemicum Fott','Gymnodinium bohemicum','Fott','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T469','','','Gymnodinium boreale Gaarder','Gymnodinium boreale','Gaarder','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T467','','','Katodinium bohemicum (Fott) Litvinenko','Katodinium bohemicum','(Fott) Litvinenko','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T472','','','Gymnodinium breve Davis','Gymnodinium breve','Davis','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T470','','','Karenia brevis (Davis) Hansen & Moestrup','Karenia brevis','(Davis) Hansen & Moestrup','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T473','','','Gymnodinium brevis','Gymnodinium brevis','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T475','','','Gymnodinium brevisulcatum Chang','Gymnodinium brevisulcatum','Chang','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T476','','','Woloszynskia pascheri (Suchlandt) von Stosch','Woloszynskia pascheri','(Suchlandt) von Stosch','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T477','','','Gymnodinium carinatum var. hiemalis Woloszynska','Gymnodinium carinatum var. hiemalis','Woloszynska','VARIETY','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T478','','','Gymnodinium carinatum Schilling','Gymnodinium carinatum','Schilling','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T480','','','Gymnodinium cestocoetes Thompson','Gymnodinium cestocoetes','Thompson','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T474','','','Karenia brevisulcata (Chang) Hansen & Moestrup','Karenia brevisulcata','(Chang) Hansen & Moestrup','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T479','','','Woloszynskia cestocoedes (Thompson) Thompson','Woloszynskia cestocoedes','(Thompson) Thompson','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T482','','','Gyrodinium chiasmonetrium Norris','Gyrodinium chiasmonetrium','Norris','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T481','','','Gymnodinium chiasmonetrum Norris','Gymnodinium chiasmonetrum','Norris','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T484','','','Gymnodinium chloroforum','Gymnodinium chloroforum','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T487','','','Gymnodinium cladochroma','Gymnodinium cladochroma','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T485','','','Gymnodinium chlorophorum Elbrächter & Schnepf','Gymnodinium chlorophorum','Elbrächter & Schnepf','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T483','','','Lepidodinium chlorophorum (Elbrächter & Schnepf) Hansen et al.','Lepidodinium chlorophorum','(Elbrächter & Schnepf) Hansen et al.','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T488','','','Gymnodinium cladochromum','Gymnodinium cladochromum','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T490','','','Gymnodinium coerulea','Gymnodinium coerulea','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T491','','','Gymnodinium coeruleum Dogiel','Gymnodinium coeruleum','Dogiel','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T486','','','Takayama cladochroma (Larsen) de Salas et al.','Takayama cladochroma','(Larsen) de Salas et al.','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T489','','','Balechina coerulea (Dogiel) Taylor','Balechina coerulea','(Dogiel) Taylor','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T493','','','Gymnodinium conicum Kofoid & Swezy','Gymnodinium conicum','Kofoid & Swezy','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T494','','','Cochlodinium constrictum (Schütt) Lemmermann','Cochlodinium constrictum','(Schütt) Lemmermann','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T495','','','Gymnodinium constrictum Schütt','Gymnodinium constrictum','Schütt','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T492','','','Spatulodinium pseudonoctiluca (Pouchet) Cachon & Cachon','Spatulodinium pseudonoctiluca','(Pouchet) Cachon & Cachon','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T499','','','Gymnodinium cornutum Pouchet','Gymnodinium cornutum','Pouchet','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T497','','','Gymnodinium contortum Schütt','Gymnodinium contortum','Schütt','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T498','','','Gyrodinium cornutum (Pouchet) Kofoid & Swezy','Gyrodinium cornutum','(Pouchet) Kofoid & Swezy','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T496','','','Gyrodinium contortum (Schütt) Kofoid & Swezy','Gyrodinium contortum','(Schütt) Kofoid & Swezy','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T501','','','Gymnodinium cornutum Schütt','Gymnodinium cornutum','Schütt','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T503','','','Gymnodinium coronatum var. glabrum Woloszynska','Gymnodinium coronatum var. glabrum','Woloszynska','VARIETY','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T502','','','Tovellia glabra (Woloszynska) Moestrup et al.','Tovellia glabra','(Woloszynska) Moestrup et al.','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T507','','','Gymnodinium corsicum','Gymnodinium corsicum','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T500','','','Gyrodinium schuetti (Schütt) Kofoid & Swezy','Gyrodinium schuetti','(Schütt) Kofoid & Swezy','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T504','','','Tovellia coronata (Woloszynska) Moestrup et al.','Tovellia coronata','(Woloszynska) Moestrup et al.','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T505','','','Gymnodinium coronatum Woloszynska','Gymnodinium coronatum','Woloszynska','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T508','','','Gyrodinium coronatum var. glabrum Woloszynska','Gyrodinium coronatum var. glabrum','Woloszynska','VARIETY','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T506','','','Gyrodinium corsicum Paulmier, Berland, Billard & Nezan','Gyrodinium corsicum','Paulmier, Berland, Billard & Nezan','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T509','','','Gymnodinium costatum var. glabrum Woloszynska','Gymnodinium costatum var. glabrum','Woloszynska','VARIETY','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T511','','','Gymnodinium crassum Pouchet','Gymnodinium crassum','Pouchet','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T510','','','Gyrodinium crassum (Pouchet) Kofoid & Swezy','Gyrodinium crassum','(Pouchet) Kofoid & Swezy','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T513','','','Chilodinium cruciatum Massart','Chilodinium cruciatum','Massart','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T512','','','Gymnodinium cruciatum (Massart) Schiller','Gymnodinium cruciatum','(Massart) Schiller','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T516','','','Gymnodinium cuneatum','Gymnodinium cuneatum','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T517','','','Gymnodinium cuspidatum Cleve-Euler','Gymnodinium cuspidatum','Cleve-Euler','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T514','','','Gymnodinium cruciatum Massart','Gymnodinium cruciatum','Massart','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T519','','','Gymnodinium dextrorsum','Gymnodinium dextrorsum','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T520','','','Cystodinium phaseolus Pascher','Cystodinium phaseolus','Pascher','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T518','','','Gymnodinium decussata','Gymnodinium decussata','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T515','','','Gyrodinium cuneatum Kofoid & Swezy','Gyrodinium cuneatum','Kofoid & Swezy','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T521','','','Gymnodinium dimorphe Baumeister','Gymnodinium dimorphe','Baumeister','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T522','','','Gymnodinium diplococcus Cleve-Euler','Gymnodinium diplococcus','Cleve-Euler','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T524','','','Gymnodinium dorsum','Gymnodinium dorsum','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T523','','','Gyrodinium dorsum Kofoid & Swezy','Gyrodinium dorsum','Kofoid & Swezy','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T525','','','Gymnodinium dubium Cleve-Euler','Gymnodinium dubium','Cleve-Euler','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T527','','','Gymnodinium edax','Gymnodinium edax','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T529','','','Gymnodinium elonga','Gymnodinium elonga','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T526','','','Glenodinium edax Schilling','Glenodinium edax','Schilling','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T530','','','Gymnodinium elongatum Hope','Gymnodinium elongatum','Hope','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T531','','','Gyrodinium estuariale Hulburt','Gyrodinium estuariale','Hulburt','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T533','','','Gymnodinium exavatum','Gymnodinium exavatum','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T532','','','Gymnodinium estuariale','Gymnodinium estuariale','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T528','','','Lessardia elongata Saldarriaga & Taylor','Lessardia elongata','Saldarriaga & Taylor','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T534','','','Gymnodinium excavatum var. dextrorsum','Gymnodinium excavatum var. dextrorsum','','VARIETY','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T537','','','Gymnodinium faba Cleve-Euler','Gymnodinium faba','Cleve-Euler','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T535','','','Gymnodinium excavatum Nygaard','Gymnodinium excavatum','Nygaard','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T538','','','Gymnodinium falcatum','Gymnodinium falcatum','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T541','','','Gymnodinium fissoides','Gymnodinium fissoides','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T536','','','Gymnodinium excavatum var. dextrosum Nygaard','Gymnodinium excavatum var. dextrosum','Nygaard','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T540','','','Gyrodinium fissoides Elbrächter','Gyrodinium fissoides','Elbrächter','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T544','','','Glenodinium foliaceum Stein','Glenodinium foliaceum','Stein','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T547','','','Gymnodinium formica','Gymnodinium formica','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T545','','','Gymnodinium foliaceum','Gymnodinium foliaceum','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T543','','','Gymnodinium fissum Levander','Gymnodinium fissum','Levander','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T539','','','Ceratoperidinium falcatum (Kofoid & Swezy) Reñé & de Salas','Ceratoperidinium falcatum','(Kofoid & Swezy) Reñé & de Salas','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T548','','','Crypthecodinium cohnii (Seligo) Chatton','Crypthecodinium cohnii','(Seligo) Chatton','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T546','','','Karlodinium veneficum (Ballantine) Larsen','Karlodinium veneficum','(Ballantine) Larsen','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T549','','','Gymnodinium fucorum Kuster','Gymnodinium fucorum','Kuster','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T550','','','Gymnodinium fungiforme Schiller','Gymnodinium fungiforme','Schiller','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T553','','','Gymnodinium fusiforme','Gymnodinium fusiforme','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T551','','','Gymnodinium fungiforme Anisimova','Gymnodinium fungiforme','Anisimova','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T552','','','Gyrodinium fusiforme Kofoid & Swezy','Gyrodinium fusiforme','Kofoid & Swezy','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T554','','','Gyrodinium falcatum Kofoid & Swezy','Gyrodinium falcatum','Kofoid & Swezy','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T555','','','Gymnodinium fusum','Gymnodinium fusum','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T556','','','Gymnodinium fusus Schütt','Gymnodinium fusus','Schütt','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T557','','','Gymnodinium galatheanum Braarud','Gymnodinium galatheanum','Braarud','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T559','','','Gymnodinium geminatum Schütt','Gymnodinium geminatum','Schütt','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T558','','','Cochlodinium geminatum (Schütt) Lemmermann','Cochlodinium geminatum','(Schütt) Lemmermann','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T560','','','Gymnodinium glabra Woloszynska','Gymnodinium glabra','Woloszynska','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T563','','','Gymnodinium glandula Herdman','Gymnodinium glandula','Herdman','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T562','','','Katodinium glandulum (Herdman) Loeblich','Katodinium glandulum','(Herdman) Loeblich','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T561','','','Gymnodinium glaciale Danysz','Gymnodinium glaciale','Danysz','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T565','','','Gymnodinium glaucum Conrad','Gymnodinium glaucum','Conrad','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T566','','','Gymnodinium gracile var. exiguum Pouchet','Gymnodinium gracile var. exiguum','Pouchet','VARIETY','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T569','','','Gymnodinium grave','Gymnodinium grave','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T567','','','Gymnodinium gracilis Lackey','Gymnodinium gracilis','Lackey','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T571','','','Gymnodinium halophila','Gymnodinium halophila','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T564','','','Amphidinium conradii (Conrad) Schiller','Amphidinium conradii','(Conrad) Schiller','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T568','','','Gyrodinium grave (Meunier) Kofoid & Swezy','Gyrodinium grave','(Meunier) Kofoid & Swezy','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T572','','','Gymnodinium halophilum Biecheler','Gymnodinium halophilum','Biecheler','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T570','','','Biecheleria baltica (Biecheler) Moestrup, Lindberg & Daugbjerg','Biecheleria baltica','(Biecheler) Moestrup, Lindberg & Daugbjerg','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T575','','','Gymnodinium helix Schütt','Gymnodinium helix','Schütt','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T573','','','Gymnodinium helicoides','Gymnodinium helicoides','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T576','','','Gymnodinium helix Pouchet','Gymnodinium helix','Pouchet','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T574','','','Cochlodinium helix (Pouchet) Lemmermann','Cochlodinium helix','(Pouchet) Lemmermann','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T579','','','Gymnodinium helveticum var. apiculatum','Gymnodinium helveticum var. apiculatum','','VARIETY','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T577','','','Gyrodinium helveticum (Penard) Takano & Horiguchi','Gyrodinium helveticum','(Penard) Takano & Horiguchi','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T580','','','Gymnodinium helveticum Penard','Gymnodinium helveticum','Penard','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T578','','','Gymnodinium helveticum f. achroum Skuja','Gymnodinium helveticum f. achroum','Skuja','FORM','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T582','','','Gymnodinium hiemale Skvortzov','Gymnodinium hiemale','Skvortzov','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T581','','','Gymnodinium helveticum var. apiculata (Zacharias) Utermöhl','Gymnodinium helveticum var. apiculata','(Zacharias) Utermöhl','VARIETY','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T583','','','Gymnodinium hiemale Woloszynska','Gymnodinium hiemale','Woloszynska','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T588','','','Gymnodinium lachryma','Gymnodinium lachryma','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T584','','','Gyrodinium hyalinum (Schilling) Kofoid & Swezy','Gyrodinium hyalinum','(Schilling) Kofoid & Swezy','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T585','','','Gymnodinium hyalinum Schilling','Gymnodinium hyalinum','Schilling','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T586','','','Gymnodinium inversum Nygaard','Gymnodinium inversum','Nygaard','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T587','','','Gymnodinium inversum var. elongatum Nygaard','Gymnodinium inversum var. elongatum','Nygaard','VARIETY','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T590','','','Gymnodinium latum Cleve-Euler','Gymnodinium latum','Cleve-Euler','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T589','','','Gyrodinium lachryma (Meunier) Kofoid & Swezy','Gyrodinium lachryma','(Meunier) Kofoid & Swezy','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T591','','','Gymnodinium lebourae Pavillard','Gymnodinium lebourae','Pavillard','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T592','','','Gymnodinium lebouriae Pavillard','Gymnodinium lebouriae','Pavillard','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T593','','','Gymnodinium lebourii Pavillard','Gymnodinium lebourii','Pavillard','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T594','','','Borghiella tenuissima (Lauterborn) Moestrup et al.','Borghiella tenuissima','(Lauterborn) Moestrup et al.','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T595','','','Gymnodinium lens Fott','Gymnodinium lens','Fott','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T597','','','Gymnodinium lenticula','Gymnodinium lenticula','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T599','','','Gymnodinium limneticum Woloszynska','Gymnodinium limneticum','Woloszynska','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T596','','','Glenodinium lenticula Pouchet','Glenodinium lenticula','Pouchet','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T601','','','Gymnodinium linguliferum','Gymnodinium linguliferum','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T598','','','Spiniferodinium limneticum (Woloszynska) Kretschmann & Gottschling','Spiniferodinium limneticum','(Woloszynska) Kretschmann & Gottschling','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T600','','','Gyrodinium lingulifera Lebour','Gyrodinium lingulifera','Lebour','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T606','','','Gymnodinium marianae','Gymnodinium marianae','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T602','','','Symbiodinium linucheae (Trench & Thinh) Lajeunesse','Symbiodinium linucheae','(Trench & Thinh) Lajeunesse','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T603','','','Gymnodinium linucheae Trench & Thinh','Gymnodinium linucheae','Trench & Thinh','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T604','','','Gymnodinium loburare Campbell','Gymnodinium loburare','Campbell','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T605','','','Balechina marianae Taylor','Balechina marianae','Taylor','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T607','','','Gymnodinium medium Cleve-Euler','Gymnodinium medium','Cleve-Euler','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T608','','','Gymnodinium metum Hulburt','Gymnodinium metum','Hulburt','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T609','','','Symbiodinium microadriaticum Freudenthal','Symbiodinium microadriaticum','Freudenthal','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T610','','','Gymnodinium microadriaticum (Freudenthal) Taylor','Gymnodinium microadriaticum','(Freudenthal) Taylor','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T615','','','Gymnodinium mikinotoi','Gymnodinium mikinotoi','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T614','','','Gymnodinium mikimotoii','Gymnodinium mikimotoii','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T613','','','Gymnodinium mikimotoi Miyaki & Kominami','Gymnodinium mikimotoi','Miyaki & Kominami','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T611','','','Gymnodinium micrum (Leadbeater & Dodge) Loeblich','Gymnodinium micrum','(Leadbeater & Dodge) Loeblich','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T612','','','Karenia mikimotoi (Miyake & Kominami) Hansen & Moestrup','Karenia mikimotoi','(Miyake & Kominami) Hansen & Moestrup','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T616','','','Gymnodinium minutissimum Massart','Gymnodinium minutissimum','Massart','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T619','','','Gymnodinium mirum Utermöhl','Gymnodinium mirum','Utermöhl','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T618','','','Gymnodinium minutum Lebour','Gymnodinium minutum','Lebour','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T620','','','Katodinium monadicum (Perty) Javornicky','Katodinium monadicum','(Perty) Javornicky','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T617','','','Heterocapsa rotundata (Lohmann) Hansen','Heterocapsa rotundata','(Lohmann) Hansen','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T622','','','Katodinium woloszynskae (Schiller) Loeblich','Katodinium woloszynskae','(Schiller) Loeblich','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T621','','','Gymnodinium monadicum (Perty) Saville-Kent','Gymnodinium monadicum','(Perty) Saville-Kent','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T626','','','Gymnodinium nagasakiensis','Gymnodinium nagasakiensis','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T624','','','Gymnodinium musei Danysz','Gymnodinium musei','Danysz','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T627','','','Gymnodinium nagasakii','Gymnodinium nagasakii','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T623','','','Gymnodinium musaei Danysz','Gymnodinium musaei','Danysz','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T628','','','Hemidinium nasutum Stein','Hemidinium nasutum','Stein','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T625','','','Gymnodinium nagasakiense Takayama & Adachi','Gymnodinium nagasakiense','Takayama & Adachi','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T629','','','Gymnodinium nasutum (Stein) Levander','Gymnodinium nasutum','(Stein) Levander','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T630','','','Biecheleria natalensis (Horiguchi & Pienaar) Moestrup','Biecheleria natalensis','(Horiguchi & Pienaar) Moestrup','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T632','','','Woloszynskia neglecta (Schilling) Thompson','Woloszynskia neglecta','(Schilling) Thompson','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T631','','','Gymnodinium natalense Horiguchi & Pienaar','Gymnodinium natalense','Horiguchi & Pienaar','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T633','','','Gymnodinium neglectum (Schilling) Lindemann','Gymnodinium neglectum','(Schilling) Lindemann','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T634','','','Gymnodinium neglectum var. astigmata Christen','Gymnodinium neglectum var. astigmata','Christen','VARIETY','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T635','','','Gymnodinium neglectum var. astigmatica','Gymnodinium neglectum var. astigmatica','','VARIETY','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T639','','','Noctiluca miliaris Suriray','Noctiluca miliaris','Suriray','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T640','','','Gymnodinium noctiluca Pouchet','Gymnodinium noctiluca','Pouchet','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T637','','','Gymnodinium nelsoni Martin','Gymnodinium nelsoni','Martin','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T636','','','Akashiwo sanguinea (Hirasaka) Hansen & Moestrup','Akashiwo sanguinea','(Hirasaka) Hansen & Moestrup','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T638','','','Gymnodinium nelsonii Martin','Gymnodinium nelsonii','Martin','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T641','','','Cystodinium novaculosum (Baumeister) Huber-Pestalozzi','Cystodinium novaculosum','(Baumeister) Huber-Pestalozzi','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T644','','','Gymnodinium nygaardi Christen','Gymnodinium nygaardi','Christen','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T643','','','Tovellia nygaardii (Christen) Moestrup et al.','Tovellia nygaardii','(Christen) Moestrup et al.','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T645','','','Gymnodinium nygaardii Christen','Gymnodinium nygaardii','Christen','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T642','','','Gymnodinium novaculosum Baumeister','Gymnodinium novaculosum','Baumeister','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T646','','','Gyrodinium oblongum Larsen & Patterson','Gyrodinium oblongum','Larsen & Patterson','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T647','','','Gymnodinium oblongum','Gymnodinium oblongum','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T648','','','Peridinium umbonatum Stein','Peridinium umbonatum','Stein','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T649','','','Gymnodinium oligoplacatum Skuja','Gymnodinium oligoplacatum','Skuja','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T651','','','Gymnodinium opimum Schütt','Gymnodinium opimum','Schütt','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T650','','','Gyrodinium opimum (Schütt) Lebour','Gyrodinium opimum','(Schütt) Lebour','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T653','','','Gymnodinium ordinatum Skuja','Gymnodinium ordinatum','Skuja','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T654','','','Gymnodinium ordinatum var. sparsum Popovsky','Gymnodinium ordinatum var. sparsum','Popovsky','VARIETY','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T655','','','Gyrodinium ovatum (Gourret) Kofoid & Swezy','Gyrodinium ovatum','(Gourret) Kofoid & Swezy','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T656','','','Gymnodinium ovatum Gourret','Gymnodinium ovatum','Gourret','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T652','','','Woloszynskia ordinata (Skuja) Thompson','Woloszynskia ordinata','(Skuja) Thompson','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T657','','','Gyrodinium ovum (Schütt) Kofoid & Swezy','Gyrodinium ovum','(Schütt) Kofoid & Swezy','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T660','','','Gymnodinium parasitica','Gymnodinium parasitica','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T661','','','Gymnodinium parasiticum Dogiel','Gymnodinium parasiticum','Dogiel','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T658','','','Gymnodinium ovum Schütt','Gymnodinium ovum','Schütt','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T659','','','Oodinium parasiticum (Dogiel) Kofoid & Swezy','Oodinium parasiticum','(Dogiel) Kofoid & Swezy','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T662','','','Gyrodinium parvulum (Schütt) Kofoid & Swezy','Gyrodinium parvulum','(Schütt) Kofoid & Swezy','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T663','','','Gymnodinium parvulum Schütt','Gymnodinium parvulum','Schütt','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T666','','','Gymnodinium pellucidum Wulff','Gymnodinium pellucidum','Wulff','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T668','','','Gymnodinium pepo','Gymnodinium pepo','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T665','','','Gyrodinium pellucidum (Wulff) Schiller','Gyrodinium pellucidum','(Wulff) Schiller','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T669','','','Gymnodinium peridinium','Gymnodinium peridinium','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T664','','','Gymnodinium pascheri (Suchlandt) Schiller','Gymnodinium pascheri','(Suchlandt) Schiller','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T667','','','Gyrodinium pepo (Schütt) Kofoid & Swezy','Gyrodinium pepo','(Schütt) Kofoid & Swezy','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T670','','','Aureodinium pigmentosum Dodge','Aureodinium pigmentosum','Dodge','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T673','','','Gymnodinium pirum Schütt','Gymnodinium pirum','Schütt','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T671','','','Gymnodinium pigmentosum (Dodge) Loeblich','Gymnodinium pigmentosum','(Dodge) Loeblich','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T675','','','Protopsis nigra (Pouchet) Kofoid & Swezy','Protopsis nigra','(Pouchet) Kofoid & Swezy','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T672','','','Cochlodinium pirum (Schütt) Lemmermann','Cochlodinium pirum','(Schütt) Lemmermann','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T676','','','Gymnodinium polyphemus var. nigrum Pouchet','Gymnodinium polyphemus var. nigrum','Pouchet','VARIETY','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T674','','','Gymnodinium polonicum (Woloszynska) Woloszynska','Gymnodinium polonicum','(Woloszynska) Woloszynska','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T677','','','Gymnodinium polyphemus var. roseum Pouchet','Gymnodinium polyphemus var. roseum','Pouchet','VARIETY','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T679','','','Gymnodinium polyphemus Pouchet','Gymnodinium polyphemus','Pouchet','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T678','','','Warnowia polyphemus (Pouchet) Schiller','Warnowia polyphemus','(Pouchet) Schiller','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T680','','','Gymnodinium polyphemus var. magna Dogiel','Gymnodinium polyphemus var. magna','Dogiel','VARIETY','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T682','','','Gymnodinium poucheti Lemmermann','Gymnodinium poucheti','Lemmermann','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T681','','','Oodinium pouchetii (Lemmermann) Chatton','Oodinium pouchetii','(Lemmermann) Chatton','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T684','','','Gymnodinium pouchettii','Gymnodinium pouchettii','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T685','','','Gyrodinium prunus (Wulff) Lebour','Gyrodinium prunus','(Wulff) Lebour','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T686','','','Gymnodinium prunus','Gymnodinium prunus','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T683','','','Gymnodinium pouchetii Lemmermann','Gymnodinium pouchetii','Lemmermann','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T688','','','Gymnodinium pseudopalustre Woloszynska','Gymnodinium pseudopalustre','Woloszynska','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T687','','','Gymnodinium pseudonoctiluca Pouchet','Gymnodinium pseudonoctiluca','Pouchet','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T689','','','Gymnodinium pseudopalustris Schiller','Gymnodinium pseudopalustris','Schiller','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T692','','','Glenodinium pulvisculus (Ehrenberg) Stein','Glenodinium pulvisculus','(Ehrenberg) Stein','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T690','','','Takayama pulchella (Larsen) de Salas et al.','Takayama pulchella','(Larsen) de Salas et al.','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T693','','','Gymnodinium pulvisculus (Ehrenberg) Stein','Gymnodinium pulvisculus','(Ehrenberg) Stein','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T691','','','Gymnodinium pulchellum Larsen','Gymnodinium pulchellum','Larsen','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T694','','','Gymnodinium pulvisculus Pouchet','Gymnodinium pulvisculus','Pouchet','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T695','','','Gymnodinium pulvisculus var. oculatum Largajolli','Gymnodinium pulvisculus var. oculatum','Largajolli','VARIETY','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T697','','','Gymnodinium pusillum Schilling','Gymnodinium pusillum','Schilling','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T699','','','Peridiniopsis quadridens (Thompson) Bourrelly','Peridiniopsis quadridens','(Thompson) Bourrelly','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T700','','','Gymnodinium quadridens','Gymnodinium quadridens','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T698','','','Gymnodinium pyrenoidosum Horiguchi & Chihara','Gymnodinium pyrenoidosum','Horiguchi & Chihara','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T696','','','Gyrodinium pusillum (Schilling) Kofoid & Swezy','Gyrodinium pusillum','(Schilling) Kofoid & Swezy','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T705','','','Gymnodinium resplendens Hulburt','Gymnodinium resplendens','Hulburt','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T701','','','Gymnodinium quadrilobatum Horiguchi & Pienaar','Gymnodinium quadrilobatum','Horiguchi & Pienaar','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T703','','','Gymnodinium rarum Litvienko','Gymnodinium rarum','Litvienko','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T702','','','Amphidinium elenkinii Skvortzov','Amphidinium elenkinii','Skvortzov','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T706','','','Gymnodinium robusta','Gymnodinium robusta','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T704','','','Gyrodinium resplendens Hulburt','Gyrodinium resplendens','Hulburt','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T707','','','Gymnodinium robustum Cleve-Euler','Gymnodinium robustum','Cleve-Euler','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T708','','','Chytriodinium roseum (Dogiel) Chatton','Chytriodinium roseum','(Dogiel) Chatton','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T709','','','Gymnodinium roseum Dogiel','Gymnodinium roseum','Dogiel','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T711','','','Gymnodinium rubrum Kofoid & Swezy','Gymnodinium rubrum','Kofoid & Swezy','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T713','','','Gymnodinium sangineum','Gymnodinium sangineum','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T712','','','Gymnodinium sanguineum Hirasaka','Gymnodinium sanguineum','Hirasaka','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T710','','','Gyrodinium rubrum (Kofoid & Swezy) Takano & Horiguchi','Gyrodinium rubrum','(Kofoid & Swezy) Takano & Horiguchi','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T716','','','Gymnodinium skvortzovii Schiller','Gymnodinium skvortzovii','Schiller','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T717','','','Gymnodinium skvortzowii','Gymnodinium skvortzowii','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T714','','','Gymnodinium simplex (Lohmann) Kofoid & Swezy','Gymnodinium simplex','(Lohmann) Kofoid & Swezy','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T715','','','Gymnodinium simplicissimum Stein','Gymnodinium simplicissimum','Stein','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T718','','','Gonyaulax spinifera (Claparède & Lachmann) Diesing','Gonyaulax spinifera','(Claparède & Lachmann) Diesing','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T719','','','Gymnodinium spinifera (Claparède & Lachmann) Diesing','Gymnodinium spinifera','(Claparède & Lachmann) Diesing','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T721','','','Gymnodinium spirale var. acuta Schütt','Gymnodinium spirale var. acuta','Schütt','VARIETY','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T722','','','Gymnodinium spirale var. cornutum Pouchet','Gymnodinium spirale var. cornutum','Pouchet','VARIETY','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T723','','','Gyrodinium mitrum Kofoid & Swezy','Gyrodinium mitrum','Kofoid & Swezy','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T720','','','Gyrodinium acutum (Schütt) Kofoid & Swezy','Gyrodinium acutum','(Schütt) Kofoid & Swezy','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T724','','','Gymnodinium spirale var. mitra Schütt','Gymnodinium spirale var. mitra','Schütt','VARIETY','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T727','','','Gymnodinium spirale var. pepo Schütt','Gymnodinium spirale var. pepo','Schütt','VARIETY','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T725','','','Gyrodinium obtusum (Schütt) Kofoid & Swezy','Gyrodinium obtusum','(Schütt) Kofoid & Swezy','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T726','','','Gymnodinium spirale var. obtusa Schütt','Gymnodinium spirale var. obtusa','Schütt','VARIETY','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T729','','','Gymnodinium spirale var. pinguis Schütt','Gymnodinium spirale var. pinguis','Schütt','VARIETY','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T731','','','Gymnodinium spirale var. striatum Pouchet','Gymnodinium spirale var. striatum','Pouchet','VARIETY','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T730','','','Gyrodinium fissum (Levander) Kofoid & Swezy','Gyrodinium fissum','(Levander) Kofoid & Swezy','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T728','','','Gyrodinium pingue (Schütt) Kofoid & Swezy','Gyrodinium pingue','(Schütt) Kofoid & Swezy','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T733','','','Gymnodinium spirale Bergh','Gymnodinium spirale','Bergh','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T732','','','Gyrodinium spirale (Bergh) Kofoid & Swezy','Gyrodinium spirale','(Bergh) Kofoid & Swezy','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T734','','','Gymnodinium splendens Lebour','Gymnodinium splendens','Lebour','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T735','','','Prosoaulax lacustris (Stein) Calado & Moestrup','Prosoaulax lacustris','(Stein) Calado & Moestrup','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T736','','','Gymnodinium stagnate','Gymnodinium stagnate','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T737','','','Cochlodinium strangulatum (Schütt) Schütt','Cochlodinium strangulatum','(Schütt) Schütt','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T738','','','Gymnodinium strangulatum Schütt','Gymnodinium strangulatum','Schütt','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T740','','','Gymnodinium striassimum','Gymnodinium striassimum','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T741','','','Gymnodinium striata','Gymnodinium striata','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T743','','','Gymnodinium striatum','Gymnodinium striatum','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T744','','','Gymnodinium sugashimanii Cachon et al.','Gymnodinium sugashimanii','Cachon et al.','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T745','','','Gonyaulax tamarensis Lebour','Gonyaulax tamarensis','Lebour','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T739','','','Gyrodinium striatissimum (Hulburt) Hansen & Moestrup','Gyrodinium striatissimum','(Hulburt) Hansen & Moestrup','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T746','','','Gymnodinium tamarensis','Gymnodinium tamarensis','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T742','','','Gymnodinium striatissimum Hulburt','Gymnodinium striatissimum','Hulburt','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T748','','','Gymnodinium tenuissimum Lauterborn','Gymnodinium tenuissimum','Lauterborn','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T749','','','Torodinium teredo (Pouchet) Kofoid & Swezy','Torodinium teredo','(Pouchet) Kofoid & Swezy','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T750','','','Gymnodinium teredo Pouchet','Gymnodinium teredo','Pouchet','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T747','','','Gymnodinium tatricum Woloszynska','Gymnodinium tatricum','Woloszynska','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T752','','','Ceratium tripos (Müller) Nitzsch','Ceratium tripos','(Müller) Nitzsch','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T751','','','Gymnodinium trigonocephalum Cleve-Euler','Gymnodinium trigonocephalum','Cleve-Euler','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T755','','','Gymnodinium tripos var. ponctic','Gymnodinium tripos var. ponctic','','VARIETY','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T753','','','Gymnodinium tripos','Gymnodinium tripos','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T756','','','Glenodinium trochoideum Stein','Glenodinium trochoideum','Stein','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T754','','','Ceratium tripos var. ponticum Jorgensen','Ceratium tripos var. ponticum','Jorgensen','VARIETY','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T760','','','Gymnodinium tylota','Gymnodinium tylota','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T757','','','Gymnodinium trochoideum Stein','Gymnodinium trochoideum','Stein','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T759','','','Gymnodinium tylotum Mapletoft et al.','Gymnodinium tylotum','Mapletoft et al.','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T762','','','Gymnodinium undulans','Gymnodinium undulans','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T761','','','Gyrodinium undulans Hulburt','Gyrodinium undulans','Hulburt','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T763','','','Gymnodinium undulatum Woloskzynska','Gymnodinium undulatum','Woloskzynska','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T764','','','Gymnodinium vation invalid','Gymnodinium vation','invalid','UNRANKED','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T767','','','Gymnodinium veris Lindemann','Gymnodinium veris','Lindemann','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T765','','','Gymnodinium veneficum Stein','Gymnodinium veneficum','Stein','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T758','','','Woloszynskia tylota (Mapletoft et al.) Bibby & Dodge','Woloszynskia tylota','(Mapletoft et al.) Bibby & Dodge','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T766','','','Gymnodinium veneficum Ballantine','Gymnodinium veneficum','Ballantine','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T768','','','Gymnodinium vertebralis','Gymnodinium vertebralis','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T771','','','Gymnodinium virescens Wood','Gymnodinium virescens','Wood','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T769','','','Gymnodinium vinugo','Gymnodinium vinugo','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T772','','','Gyrodinium viride Kofoid & Swezy','Gyrodinium viride','Kofoid & Swezy','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T773','','','Gymnodinium viride Schütt','Gymnodinium viride','Schütt','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T774','','','Gymnodinium vitiligo Ballantine','Gymnodinium vitiligo','Ballantine','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T770','','','Karlodinium vitiligo (Ballantine) Larsen','Karlodinium vitiligo','(Ballantine) Larsen','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T778','','','Gymnodinium wigrense Woloszynska','Gymnodinium wigrense','Woloszynska','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T777','','','Gymnodinium vorticella Stein','Gymnodinium vorticella','Stein','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T780','','','Gymnodium pigmentosum','Gymnodium pigmentosum','','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T775','','','Gymnodinium vorax Massart','Gymnodinium vorax','Massart','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T776','','','Katodinium vorticellum (Stein) Loeblich','Katodinium vorticellum','(Stein) Loeblich','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T779','','','Gymnodinium woloszynskae Pascher','Gymnodinium woloszynskae','Pascher','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T781','','','Gymnodinium acutiusculum Okolodkov','Gymnodinium acutiusculum','Okolodkov','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T783','','','Gymnodinium bilobatum van Meel','Gymnodinium bilobatum','van Meel','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T782','','','Gymnodinium aestivale Skvortzov','Gymnodinium aestivale','Skvortzov','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T786','','','Gymnodinium depressum Skvortzov','Gymnodinium depressum','Skvortzov','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T785','','','Gymnodinium cyaneum Schiller','Gymnodinium cyaneum','Schiller','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T787','','','Gymnodinium diamphidium Norris','Gymnodinium diamphidium','Norris','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T784','','','Gymnodinium cnodax Conrad & Kufferath','Gymnodinium cnodax','Conrad & Kufferath','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T790','','','Gymnodinium galeiforme Okolodkov','Gymnodinium galeiforme','Okolodkov','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T788','','','Gymnodinium frigidum Woloszynska','Gymnodinium frigidum','Woloszynska','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T789','','','Gymnodinium fukushimai Hada','Gymnodinium fukushimai','Hada','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T792','','','Gymnodinium mammosum van Meel','Gymnodinium mammosum','van Meel','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T793','','','Gymnodinium massarti (Conrad) Schiller','Gymnodinium massarti','(Conrad) Schiller','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T791','','','Gymnodinium luteo-viride van Meel','Gymnodinium luteo-viride','van Meel','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T795','','','Gymnodinium nucaceum Okolodkov','Gymnodinium nucaceum','Okolodkov','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T796','','','Gymnodinium obliquum Okolodkov','Gymnodinium obliquum','Okolodkov','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T794','','','Gymnodinium maximum Nordli','Gymnodinium maximum','Nordli','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T797','','','Gymnodinium ovato-capitatum van Meel','Gymnodinium ovato-capitatum','van Meel','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T799','','','Gymnodinium pingue van Meel','Gymnodinium pingue','van Meel','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T798','','','Gymnodinium ovoideum Okolodkov','Gymnodinium ovoideum','Okolodkov','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T802','','','Gymnodinium rotundatum Skvortzov','Gymnodinium rotundatum','Skvortzov','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T801','','','Gymnodinium rete Schütt','Gymnodinium rete','Schütt','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T800','','','Gymnodinium planctonicum Skvortzov','Gymnodinium planctonicum','Skvortzov','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T804','','','Gymnodinium servatum Busch','Gymnodinium servatum','Busch','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T805','','','Gymnodinium sinuatum Skvortzov','Gymnodinium sinuatum','Skvortzov','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T803','','','Gymnodinium scaphium van Meel','Gymnodinium scaphium','van Meel','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T806','','','Gymnodinium suffuscum van Meel','Gymnodinium suffuscum','van Meel','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T809','','','Gymnodinium vas van Meel','Gymnodinium vas','van Meel','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T808','','','Gymnodinium triangularis Lebour','Gymnodinium triangularis','Lebour','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T807','','','Gymnodinium telma van Meel','Gymnodinium telma','van Meel','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T812','','','Dinophyceae Fritsch','Dinophyceae','Fritsch','CLASS','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T813','','','Amphidiniopsidaceae','Amphidiniopsidaceae','','FAMILY','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T810','','','Gymnodinium vastum Busch','Gymnodinium vastum','Busch','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T811','','','Gymnodinium vernale Skvortzov','Gymnodinium vernale','Skvortzov','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T816','','','Katodinium','Katodinium','','GENUS','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T817','','','Tovelliaceae','Tovelliaceae','','FAMILY','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T814','','','Glenodiniaceae','Glenodiniaceae','','FAMILY','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T815','','','Cochlodinium','Cochlodinium','','GENUS','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T819','','','Suessiaceae','Suessiaceae','','FAMILY','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T823','','','Phytodiniaceae','Phytodiniaceae','','FAMILY','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T818','','','Pelagodinium','Pelagodinium','','GENUS','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T821','','','Heterodiniaceae','Heterodiniaceae','','FAMILY','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T822','','','Cystodinium Klebs','Cystodinium','Klebs','GENUS','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T824','','','Karenia','Karenia','','GENUS','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T829','','','Takayama','Takayama','','GENUS','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T830','','','Balechina','Balechina','','GENUS','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T825','','','Kareniaceae','Kareniaceae','','FAMILY','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T827','','','Woloszynskiaceae','Woloszynskiaceae','','FAMILY','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T828','','','Lepidodinium','Lepidodinium','','GENUS','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T826','','','Woloszynskia','Woloszynskia','','GENUS','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T831','','','Spatulodinium','Spatulodinium','','GENUS','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T836','','','Lessardia','Lessardia','','GENUS','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T833','','','Tovellia','Tovellia','','GENUS','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T835','','','Glenodinium','Glenodinium','','GENUS','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T837','','','Podolampadaceae','Podolampadaceae','','FAMILY','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T838','','','Ceratoperidinium','Ceratoperidinium','','GENUS','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T832','','','Kofoidiniaceae','Kofoidiniaceae','','FAMILY','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T834','','','Chilodinium Massart','Chilodinium','Massart','GENUS','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T842','','','Crypthecodiniaceae','Crypthecodiniaceae','','FAMILY','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T843','','','Symbiodinium','Symbiodinium','','GENUS','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T841','','','Crypthecodinium','Crypthecodinium','','GENUS','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T839','','','Ceratoperidiniaeceae','Ceratoperidiniaeceae','','FAMILY','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T840','','','Karlodinium','Karlodinium','','GENUS','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T844','','','Heterocapsa','Heterocapsa','','GENUS','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T849','','','Noctilucaceae','Noctilucaceae','','FAMILY','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T847','','','Akashiwo','Akashiwo','','GENUS','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T845','','','Heterocapsaceae','Heterocapsaceae','','FAMILY','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T848','','','Noctiluca','Noctiluca','','GENUS','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T846','','','Hemidinium','Hemidinium','','GENUS','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T850','','','Parvodinium umbonatum (Stein) Carty','Parvodinium umbonatum','(Stein) Carty','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T855','','','Oodiniaceae','Oodiniaceae','','FAMILY','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T851','','','Parvodinium Carty','Parvodinium','Carty','GENUS','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T854','','','Oodinium','Oodinium','','GENUS','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T856','','','Aureodinium','Aureodinium','','GENUS','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T852','','','Peridiniaceae','Peridiniaceae','','FAMILY','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T859','','','Borghiella','Borghiella','','GENUS','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T860','','','Borghiellaceae','Borghiellaceae','','FAMILY','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T857','','','Warnowiaceae','Warnowiaceae','','FAMILY','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T858','','','Amphidinium','Amphidinium','','GENUS','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T863','','','Gonyaulax','Gonyaulax','','GENUS','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T861','','','Chytriodinium','Chytriodinium','','GENUS','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T862','','','Chytriodiniaceae','Chytriodiniaceae','','FAMILY','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T865','','','Prosoaulax','Prosoaulax','','GENUS','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T866','','','Torodinium','Torodinium','','GENUS','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T864','','','Gonyaulacaceae','Gonyaulacaceae','','FAMILY','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T869','','','Ceratiaceae','Ceratiaceae','','FAMILY','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T867','','','Torodiniaceae','Torodiniaceae','','FAMILY','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T868','','','Ceratium','Ceratium','','GENUS','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T853','','','Noctiluca scintillans (Macartney) Kofoid & Swezy','Noctiluca scintillans','(Macartney) Kofoid & Swezy','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T873','','','Thoracosphaeraceae','Thoracosphaeraceae','','FAMILY','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T871','','','Tyrannodinium edax (Schilling) Calado','Tyrannodinium edax','(Schilling) Calado','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T875','','','Cucumeridinium Gómez, Lopez-Garcia, Takayama & Moreira','Cucumeridinium','Gómez, Lopez-Garcia, Takayama & Moreira','GENUS','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T874','','','Cucumeridinium coeruleum (Dogiel) Gómez, Lopez-Garcia, Takayama & Moreira','Cucumeridinium coeruleum','(Dogiel) Gómez, Lopez-Garcia, Takayama & Moreira','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T870','','','Takayama acrotrocha (Larsen) de Salas, Bolch & Hallegraeff','Takayama acrotrocha','(Larsen) de Salas, Bolch & Hallegraeff','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T872','','','Tyrannodinium Calado, Craveiro, Daugbjerg & Moestrup','Tyrannodinium','Calado, Craveiro, Daugbjerg & Moestrup','GENUS','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T879','','','Dinotrichaceae','Dinotrichaceae','','FAMILY','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T878','','','Kryptoperidinium','Kryptoperidinium','','GENUS','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T881','','','Polykrikos','Polykrikos','','GENUS','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T883','','','Diplopsalis','Diplopsalis','','GENUS','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T876','','','Karlodinium corsicum (Paulmier et al.) Siano & Zingone','Karlodinium corsicum','(Paulmier et al.) Siano & Zingone','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T882','','','Diplopsalis lenticula Bergh','Diplopsalis lenticula','Bergh','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T877','','','Kryptoperidinium foliaceum (Stein) Lindemann','Kryptoperidinium foliaceum','(Stein) Lindemann','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T884','','','Diplopsalidaceae','Diplopsalidaceae','','FAMILY','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T880','','','Polykrikos geminatus (Schütt) Qiu & Lin','Polykrikos geminatus','(Schütt) Qiu & Lin','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T888','','','Moestrupia','Moestrupia','','GENUS','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T886','','','Opisthoaulax','Opisthoaulax','','GENUS','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T885','','','Opisthoaulax woloszynskae (Schiller) Calado','Opisthoaulax woloszynskae','(Schiller) Calado','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T892','','','Barrufeta','Barrufeta','','GENUS','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T889','','','Chytriodinium parasiticum (Dogiel) Chatton','Chytriodinium parasiticum','(Dogiel) Chatton','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T887','','','Moestrupia oblonga (Larsen & Patterson) Hansen & Daugbjerg','Moestrupia oblonga','(Larsen & Patterson) Hansen & Daugbjerg','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T894','','','Alexandrium','Alexandrium','','GENUS','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T891','','','Barrufeta resplendens (Hulbert) Gu, Luo & Mertens','Barrufeta resplendens','(Hulbert) Gu, Luo & Mertens','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T896','','','Tripos','Tripos','','GENUS','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T898','','','Scrippsiella','Scrippsiella','','GENUS','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T893','','','Alexandrium tamarense (Lebour) Balech','Alexandrium tamarense','(Lebour) Balech','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T890','','','Prosoaulax lacustris (Stein) Calado & Moestrup','Prosoaulax lacustris','(Stein) Calado & Moestrup','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T895','','','Tripos muelleri Bory','Tripos muelleri','Bory','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T899','','','Opisthoaulax vorticella (Stein) Calado','Opisthoaulax vorticella','(Stein) Calado','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T901','','','Gymnodinium gracile Kofoid & Swezy','Gymnodinium gracile','Kofoid & Swezy','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T902','','','Gymnodinium coeruleum Antipova','Gymnodinium coeruleum','Antipova','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T897','','','Scrippsiella acuminata (Ehrenberg) Kretschmann, Elbrächter, Zinssmeister, Soehner,Kirsch, Kusber & Gottschling','Scrippsiella acuminata','(Ehrenberg) Kretschmann, Elbrächter, Zinssmeister, Soehner,Kirsch, Kusber & Gottschling','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T903','','','Cucumeridinium cucumis (Schütt) Gómez, Lopez-Garcia, Takayama & Moreira','Cucumeridinium cucumis','(Schütt) Gómez, Lopez-Garcia, Takayama & Moreira','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T904','','','Balechina coerulea Taylor','Balechina coerulea','Taylor','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T900','','','Balechina pachydermata (Kofoid & Swezy) Loeblich & Loeblich','Balechina pachydermata','(Kofoid & Swezy) Loeblich & Loeblich','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T906','','','Gymnodinium mirabile Penard','Gymnodinium mirabile','Penard','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T905','','','Cucumeridinium lira (Kofoid & Swezy) Gómez, Lopez-Garcia, Takayama & Moreira','Cucumeridinium lira','(Kofoid & Swezy) Gómez, Lopez-Garcia, Takayama & Moreira','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
INSERT INTO name VALUES('T907','','','Gymnodinium plasticum Wang, Luo, Mertens, McCarthy & Gu','Gymnodinium plasticum','Wang, Luo, Mertens, McCarthy & Gu','SPECIES','','','','','','','',NULL,'','','','','','','','','','','','','','','','','',NULL,'','','','','');
CREATE TABLE taxon (
  id TEXT PRIMARY KEY,
  alternative_id TEXT DEFAULT '', -- scope:id, id sep ','
  gn_local_id TEXT DEFAULT '', -- internal ID from the source
  gn_global_id TEXT DEFAULT '', -- GUID attached to the record.
  source_id TEXT REFERENCES source DEFAULT '',
  parent_id TEXT REFERENCES taxon DEFAULT '',
  ordinal INTEGER DEFAULT NULL, -- for sorting
  branch_length INTEGER DEFAULT NULL, --length of 'bread crumbs'
  name_id TEXT NOT NULL REFERENCES name DEFAULT '',
  name_phrase TEXT DEFAULT '', -- eg `sensu stricto` and other annotations
  according_to_id TEXT REFERENCES reference DEFAULT '',
  according_to_page TEXT DEFAULT '',
  according_to_page_link TEXT DEFAULT '',
  scrutinizer TEXT DEFAULT '',
  scrutinizer_id TEXT DEFAULT '', -- ORCID usually
  scrutinizer_date TEXT DEFAULT '',
  provisional INTEGER DEFAULT NULL, -- bool
  reference_id TEXT DEFAULT '', -- list of references about the taxon hypothesis
  extinct INTEGER DEFAULT NULL, -- bool
  temporal_range_start_id TEXT REFERENCES geo_time DEFAULT '',
  temporal_range_end_id TEXT REFERENCES geo_time DEFAULT '',
  environment_id TEXT DEFAULT '', -- environment ids sep by ','
  species TEXT DEFAULT '',
  section TEXT DEFAULT '',
  subgenus TEXT DEFAULT '',
  genus TEXT DEFAULT '',
  subtribe TEXT DEFAULT '',
  tribe TEXT DEFAULT '',
  subfamily TEXT DEFAULT '',
  family TEXT DEFAULT '',
  superfamily TEXT DEFAULT '',
  suborder TEXT DEFAULT '',
  "order" TEXT DEFAULT '',
  subclass TEXT DEFAULT '',
  class TEXT DEFAULT '',
  subphylum TEXT DEFAULT '',
  phylum TEXT DEFAULT '',
  kingdom TEXT DEFAULT '',
  link TEXT DEFAULT '',
  remarks TEXT DEFAULT '',
  modified TEXT DEFAULT '',
  modified_by TEXT DEFAULT ''
) STRICT;
INSERT INTO taxon VALUES('T001','','','','','T161',NULL,NULL,'T001','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T002','','','','','T161',NULL,NULL,'T002','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T004','','','','','T161',NULL,NULL,'T004','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T003','','','','','T161',NULL,NULL,'T003','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T006','','','','','T161',NULL,NULL,'T006','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T007','','','','','T161',NULL,NULL,'T007','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T008','','','','','T161',NULL,NULL,'T008','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T011','','','','','T161',NULL,NULL,'T011','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T009','','','','','T161',NULL,NULL,'T009','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T010','','','','','T161',NULL,NULL,'T010','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T012','','','','','T161',NULL,NULL,'T012','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T013','','','','','T161',NULL,NULL,'T013','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T015','','','','','T161',NULL,NULL,'T015','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T018','','','','','T161',NULL,NULL,'T018','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T017','','','','','T161',NULL,NULL,'T017','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T020','','','','','T161',NULL,NULL,'T020','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T019','','','','','T161',NULL,NULL,'T019','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T016','','','','','T161',NULL,NULL,'T016','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T021','','','','','T161',NULL,NULL,'T021','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T023','','','','','T161',NULL,NULL,'T023','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T022','','','','','T161',NULL,NULL,'T022','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T025','','','','','T161',NULL,NULL,'T025','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T026','','','','','T161',NULL,NULL,'T026','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T024','','','','','T161',NULL,NULL,'T024','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T027','','','','','T161',NULL,NULL,'T027','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T305','','','','','T027',NULL,NULL,'T305','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T029','','','','','T161',NULL,NULL,'T029','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T028','','','','','T161',NULL,NULL,'T028','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T030','','','','','T161',NULL,NULL,'T030','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T033','','','','','T161',NULL,NULL,'T033','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T032','','','','','T161',NULL,NULL,'T032','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T031','','','','','T161',NULL,NULL,'T031','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T034','','','','','T161',NULL,NULL,'T034','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T037','','','','','T161',NULL,NULL,'T037','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T035','','','','','T161',NULL,NULL,'T035','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T036','','','','','T161',NULL,NULL,'T036','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T039','','','','','T161',NULL,NULL,'T039','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T038','','','','','T161',NULL,NULL,'T038','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T040','','','','','T161',NULL,NULL,'T040','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T041','','','','','T161',NULL,NULL,'T041','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T042','','','','','T161',NULL,NULL,'T042','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T046','','','','','T161',NULL,NULL,'T046','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T043','','','','','T161',NULL,NULL,'T043','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T044','','','','','T874',NULL,NULL,'T044','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T047','','','','','T161',NULL,NULL,'T047','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T045','','','','','T161',NULL,NULL,'T045','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T048','','','','','T161',NULL,NULL,'T048','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T049','','','','','T161',NULL,NULL,'T049','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T052','','','','','T161',NULL,NULL,'T052','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T050','','','','','T161',NULL,NULL,'T050','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T051','','','','','T161',NULL,NULL,'T051','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T054','','','','','T161',NULL,NULL,'T054','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T055','','','','','T161',NULL,NULL,'T055','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T058','','','','','T161',NULL,NULL,'T058','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T059','','','','','T161',NULL,NULL,'T059','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T057','','','','','T161',NULL,NULL,'T057','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T060','','','','','T161',NULL,NULL,'T060','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T066','','','','','T161',NULL,NULL,'T066','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T065','','','','','T161',NULL,NULL,'T065','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T064','','','','','T161',NULL,NULL,'T064','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T067','','','','','T161',NULL,NULL,'T067','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T068','','','','','T161',NULL,NULL,'T068','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T070','','','','','T161',NULL,NULL,'T070','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T071','','','','','T161',NULL,NULL,'T071','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T069','','','','','T161',NULL,NULL,'T069','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T062','','','','','T161',NULL,NULL,'T062','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T075','','','','','T161',NULL,NULL,'T075','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T073','','','','','T161',NULL,NULL,'T073','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T077','','','','','T161',NULL,NULL,'T077','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T078','','','','','T161',NULL,NULL,'T078','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T072','','','','','T161',NULL,NULL,'T072','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T076','','','','','T161',NULL,NULL,'T076','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T081','','','','','T161',NULL,NULL,'T081','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T080','','','','','T161',NULL,NULL,'T080','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T083','','','','','T161',NULL,NULL,'T083','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T082','','','','','T161',NULL,NULL,'T082','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T085','','','','','T161',NULL,NULL,'T085','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T084','','','','','T161',NULL,NULL,'T084','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T086','','','','','T161',NULL,NULL,'T086','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T087','','','','','T161',NULL,NULL,'T087','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T089','','','','','T161',NULL,NULL,'T089','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T088','','','','','T161',NULL,NULL,'T088','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T090','','','','','T161',NULL,NULL,'T090','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T092','','','','','T161',NULL,NULL,'T092','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T091','','','','','T161',NULL,NULL,'T091','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T096','','','','','T161',NULL,NULL,'T096','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T094','','','','','T161',NULL,NULL,'T094','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T095','','','','','T161',NULL,NULL,'T095','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T093','','','','','T161',NULL,NULL,'T093','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T097','','','','','T161',NULL,NULL,'T097','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T098','','','','','T161',NULL,NULL,'T098','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T101','','','','','T161',NULL,NULL,'T101','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T099','','','','','T161',NULL,NULL,'T099','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T100','','','','','T161',NULL,NULL,'T100','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T102','','','','','T161',NULL,NULL,'T102','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T103','','','','','T161',NULL,NULL,'T103','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T105','','','','','T161',NULL,NULL,'T105','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T104','','','','','T161',NULL,NULL,'T104','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T106','','','','','T161',NULL,NULL,'T106','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T108','','','','','T161',NULL,NULL,'T108','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T107','','','','','T161',NULL,NULL,'T107','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T111','','','','','T161',NULL,NULL,'T111','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T109','','','','','T161',NULL,NULL,'T109','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T114','','','','','T161',NULL,NULL,'T114','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T112','','','','','T161',NULL,NULL,'T112','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T110','','','','','T161',NULL,NULL,'T110','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T115','','','','','T161',NULL,NULL,'T115','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T116','','','','','T161',NULL,NULL,'T116','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T113','','','','','T161',NULL,NULL,'T113','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T118','','','','','T161',NULL,NULL,'T118','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T120','','','','','T161',NULL,NULL,'T120','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T119','','','','','T161',NULL,NULL,'T119','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T353','','','','','T120',NULL,NULL,'T353','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T121','','','','','T161',NULL,NULL,'T121','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T122','','','','','T161',NULL,NULL,'T122','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T296','','','','','T161',NULL,NULL,'T296','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T123','','','','','T161',NULL,NULL,'T123','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T124','','','','','T161',NULL,NULL,'T124','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T125','','','','','T161',NULL,NULL,'T125','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T127','','','','','T161',NULL,NULL,'T127','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T126','','','','','T161',NULL,NULL,'T126','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T129','','','','','T161',NULL,NULL,'T129','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T128','','','','','T161',NULL,NULL,'T128','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T130','','','','','T161',NULL,NULL,'T130','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T131','','','','','T161',NULL,NULL,'T131','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T134','','','','','T161',NULL,NULL,'T134','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T133','','','','','T161',NULL,NULL,'T133','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T132','','','','','T161',NULL,NULL,'T132','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T135','','','','','T161',NULL,NULL,'T135','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T137','','','','','T161',NULL,NULL,'T137','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T136','','','','','T161',NULL,NULL,'T136','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T140','','','','','T161',NULL,NULL,'T140','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T139','','','','','T161',NULL,NULL,'T139','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T141','','','','','T161',NULL,NULL,'T141','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T142','','','','','T161',NULL,NULL,'T142','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T143','','','','','T161',NULL,NULL,'T143','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T161','','','','','T285',NULL,NULL,'T161','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T159','','','','','T161',NULL,NULL,'T159','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T167','','','','','T161',NULL,NULL,'T167','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T171','','','','','T161',NULL,NULL,'T171','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T172','','','','','T161',NULL,NULL,'T172','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T176','','','','','T161',NULL,NULL,'T176','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T174','','','','','T161',NULL,NULL,'T174','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T173','','','','','T161',NULL,NULL,'T173','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T175','','','','','T161',NULL,NULL,'T175','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T177','','','','','T161',NULL,NULL,'T177','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T178','','','','','T161',NULL,NULL,'T178','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T179','','','','','T161',NULL,NULL,'T179','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T180','','','','','T161',NULL,NULL,'T180','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T183','','','','','T161',NULL,NULL,'T183','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T181','','','','','T161',NULL,NULL,'T181','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T184','','','','','T161',NULL,NULL,'T184','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T185','','','','','T161',NULL,NULL,'T185','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T187','','','','','T161',NULL,NULL,'T187','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T186','','','','','T161',NULL,NULL,'T186','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T188','','','','','T161',NULL,NULL,'T188','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T189','','','','','T161',NULL,NULL,'T189','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T190','','','','','T161',NULL,NULL,'T190','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T191','','','','','T161',NULL,NULL,'T191','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T194','','','','','T161',NULL,NULL,'T194','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T196','','','','','T161',NULL,NULL,'T196','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T192','','','','','T161',NULL,NULL,'T192','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T195','','','','','T161',NULL,NULL,'T195','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T199','','','','','T161',NULL,NULL,'T199','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T197','','','','','T161',NULL,NULL,'T197','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T200','','','','','T161',NULL,NULL,'T200','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T202','','','','','T161',NULL,NULL,'T202','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T201','','','','','T161',NULL,NULL,'T201','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T203','','','','','T161',NULL,NULL,'T203','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T204','','','','','T161',NULL,NULL,'T204','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T205','','','','','T161',NULL,NULL,'T205','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T206','','','','','T161',NULL,NULL,'T206','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T208','','','','','T161',NULL,NULL,'T208','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T207','','','','','T161',NULL,NULL,'T207','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T210','','','','','T161',NULL,NULL,'T210','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T209','','','','','T161',NULL,NULL,'T209','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T211','','','','','T161',NULL,NULL,'T211','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T212','','','','','T161',NULL,NULL,'T212','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T214','','','','','T161',NULL,NULL,'T214','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T215','','','','','T161',NULL,NULL,'T215','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T216','','','','','T161',NULL,NULL,'T216','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T213','','','','','T161',NULL,NULL,'T213','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T217','','','','','T161',NULL,NULL,'T217','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T220','','','','','T161',NULL,NULL,'T220','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T219','','','','','T161',NULL,NULL,'T219','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T218','','','','','T161',NULL,NULL,'T218','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T224','','','','','T161',NULL,NULL,'T224','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T226','','','','','T161',NULL,NULL,'T226','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T228','','','','','T161',NULL,NULL,'T228','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T229','','','','','T161',NULL,NULL,'T229','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T227','','','','','T161',NULL,NULL,'T227','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T234','','','','','T161',NULL,NULL,'T234','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T233','','','','','T161',NULL,NULL,'T233','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T232','','','','','T161',NULL,NULL,'T232','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T231','','','','','T161',NULL,NULL,'T231','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T230','','','','','T161',NULL,NULL,'T230','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T237','','','','','T161',NULL,NULL,'T237','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T238','','','','','T161',NULL,NULL,'T238','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T235','','','','','T161',NULL,NULL,'T235','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T241','','','','','T161',NULL,NULL,'T241','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T240','','','','','T161',NULL,NULL,'T240','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T243','','','','','T161',NULL,NULL,'T243','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T242','','','','','T161',NULL,NULL,'T242','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T245','','','','','T161',NULL,NULL,'T245','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T244','','','','','T161',NULL,NULL,'T244','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T246','','','','','T161',NULL,NULL,'T246','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T249','','','','','T161',NULL,NULL,'T249','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T248','','','','','T161',NULL,NULL,'T248','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T250','','','','','T161',NULL,NULL,'T250','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T252','','','','','T161',NULL,NULL,'T252','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T364','','','','','T161',NULL,NULL,'T364','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T366','','','','','T161',NULL,NULL,'T366','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T259','','','','','T161',NULL,NULL,'T259','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T257','','','','','T161',NULL,NULL,'T257','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T258','','','','','T161',NULL,NULL,'T258','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T262','','','','','T261',NULL,NULL,'T262','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T261','','','','','T161',NULL,NULL,'T261','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T263','','','','','T161',NULL,NULL,'T263','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T264','','','','','T161',NULL,NULL,'T264','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T266','','','','','T161',NULL,NULL,'T266','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T267','','','','','T161',NULL,NULL,'T267','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T270','','','','','T161',NULL,NULL,'T270','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T265','','','','','T161',NULL,NULL,'T265','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T271','','','','','T161',NULL,NULL,'T271','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T268','','','','','T161',NULL,NULL,'T268','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T269','','','','','T161',NULL,NULL,'T269','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T272','','','','','T161',NULL,NULL,'T272','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T276','','','','','T256',NULL,NULL,'T276','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T273','','','','','T161',NULL,NULL,'T273','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T278','','','','','T285',NULL,NULL,'T278','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T277','','','','','T276',NULL,NULL,'T277','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T275','','','','','T161',NULL,NULL,'T275','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T284','','','','','T161',NULL,NULL,'T284','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T280','','','','','T278',NULL,NULL,'T280','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T286','','','','','',NULL,NULL,'T286','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T285','','','','','',NULL,NULL,'T285','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T282','','','','','T278',NULL,NULL,'T282','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T289','','','','','T161',NULL,NULL,'T289','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T283','','','','','T278',NULL,NULL,'T283','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T287','','','','','T288',NULL,NULL,'T287','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T291','','','','','T292',NULL,NULL,'T291','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T288','','','','','T285',NULL,NULL,'T288','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T292','','','','','T285',NULL,NULL,'T292','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T293','','','','','T285',NULL,NULL,'T293','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T294','','','','','T293',NULL,NULL,'T294','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T380','','','','','T161',NULL,NULL,'T380','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T381','','','','','T161',NULL,NULL,'T381','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T383','','','','','T161',NULL,NULL,'T383','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T385','','','','','T161',NULL,NULL,'T385','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T387','','','','','T161',NULL,NULL,'T387','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T389','','','','','T387',NULL,NULL,'T389','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T391','','','','','T161',NULL,NULL,'T391','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T392','','','','','T161',NULL,NULL,'T392','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T396','','','','','T161',NULL,NULL,'T396','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T394','','','','','T161',NULL,NULL,'T394','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T398','','','','','T161',NULL,NULL,'T398','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T400','','','','','T398',NULL,NULL,'T400','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T401','','','','','T161',NULL,NULL,'T401','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T403','','','','','T161',NULL,NULL,'T403','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T402','','','','','T161',NULL,NULL,'T402','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T405','','','','','T161',NULL,NULL,'T405','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T408','','','','','T161',NULL,NULL,'T408','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T410','','','','','T161',NULL,NULL,'T410','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T407','','','','','T405',NULL,NULL,'T407','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T411','','','','','T161',NULL,NULL,'T411','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T414','','','','','T161',NULL,NULL,'T414','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T412','','','','','T161',NULL,NULL,'T412','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T415','','','','','T161',NULL,NULL,'T415','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T416','','','','','T161',NULL,NULL,'T416','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T419','','','','','T161',NULL,NULL,'T419','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T418','','','','','T161',NULL,NULL,'T418','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T421','','','','','T161',NULL,NULL,'T421','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T423','','','','','T161',NULL,NULL,'T423','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T425','','','','','T161',NULL,NULL,'T425','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T428','','','','','T161',NULL,NULL,'T428','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T430','','','','','T161',NULL,NULL,'T430','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T426','','','','','T427',NULL,NULL,'T426','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T427','','','','','T161',NULL,NULL,'T427','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T431','','','','','T161',NULL,NULL,'T431','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T436','','','','','T285',NULL,NULL,'T436','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T438','','','','','',NULL,NULL,'T438','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T432','','','','','T161',NULL,NULL,'T432','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T439','','','','','T441',NULL,NULL,'T439','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T441','','','','','T813',NULL,NULL,'T441','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T446','','','','','',NULL,NULL,'T446','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T445','','','','','T814',NULL,NULL,'T445','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T448','','','','','',NULL,NULL,'T448','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T447','','','','','',NULL,NULL,'T447','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T451','','','','','T278',NULL,NULL,'T451','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T455','','','','','',NULL,NULL,'T455','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T452','','','','','T815',NULL,NULL,'T452','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T457','','','','','T816',NULL,NULL,'T457','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T462','','','','','T161',NULL,NULL,'T462','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T458','','','','','T818',NULL,NULL,'T458','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T463','','','','','T822',NULL,NULL,'T463','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T465','','','','','T816',NULL,NULL,'T465','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T469','','','','','',NULL,NULL,'T469','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T467','','','','','T816',NULL,NULL,'T467','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T470','','','','','T824',NULL,NULL,'T470','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T476','','','','','T826',NULL,NULL,'T476','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T474','','','','','T824',NULL,NULL,'T474','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T479','','','','','T826',NULL,NULL,'T479','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T482','','','','','T436',NULL,NULL,'T482','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T483','','','','','T828',NULL,NULL,'T483','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T486','','','','','T829',NULL,NULL,'T486','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T494','','','','','T815',NULL,NULL,'T494','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T492','','','','','T831',NULL,NULL,'T492','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T498','','','','','T436',NULL,NULL,'T498','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T496','','','','','T436',NULL,NULL,'T496','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T502','','','','','T833',NULL,NULL,'T502','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T500','','','','','T436',NULL,NULL,'T500','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T504','','','','','T833',NULL,NULL,'T504','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T510','','','','','T436',NULL,NULL,'T510','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T512','','','','','T161',NULL,NULL,'T512','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T520','','','','','T822',NULL,NULL,'T520','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T515','','','','','T436',NULL,NULL,'T515','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T523','','','','','T436',NULL,NULL,'T523','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T531','','','','','T436',NULL,NULL,'T531','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T528','','','','','T836',NULL,NULL,'T528','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T540','','','','','T436',NULL,NULL,'T540','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T539','','','','','T838',NULL,NULL,'T539','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T548','','','','','T841',NULL,NULL,'T548','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T546','','','','','T840',NULL,NULL,'T546','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T552','','','','','T436',NULL,NULL,'T552','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T562','','','','','T816',NULL,NULL,'T562','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T564','','','','','T858',NULL,NULL,'T564','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T568','','','','','T436',NULL,NULL,'T568','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T570','','','','','T292',NULL,NULL,'T570','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T574','','','','','T815',NULL,NULL,'T574','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T577','','','','','T436',NULL,NULL,'T577','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T584','','','','','T436',NULL,NULL,'T584','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T589','','','','','T436',NULL,NULL,'T589','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T594','','','','','T859',NULL,NULL,'T594','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T598','','','','','T293',NULL,NULL,'T598','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T600','','','','','T436',NULL,NULL,'T600','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T602','','','','','T843',NULL,NULL,'T602','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T609','','','','','T843',NULL,NULL,'T609','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T612','','','','','T824',NULL,NULL,'T612','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T620','','','','','T816',NULL,NULL,'T620','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T617','','','','','T844',NULL,NULL,'T617','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T628','','','','','T846',NULL,NULL,'T628','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T630','','','','','T292',NULL,NULL,'T630','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T632','','','','','T826',NULL,NULL,'T632','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T636','','','','','T847',NULL,NULL,'T636','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T641','','','','','T822',NULL,NULL,'T641','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T643','','','','','T833',NULL,NULL,'T643','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T650','','','','','T436',NULL,NULL,'T650','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T655','','','','','T436',NULL,NULL,'T655','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T652','','','','','T826',NULL,NULL,'T652','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T657','','','','','T436',NULL,NULL,'T657','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T662','','','','','T436',NULL,NULL,'T662','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T665','','','','','T436',NULL,NULL,'T665','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T667','','','','','T436',NULL,NULL,'T667','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T670','','','','','T856',NULL,NULL,'T670','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T675','','','','','T857',NULL,NULL,'T675','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T672','','','','','T815',NULL,NULL,'T672','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T678','','','','','T857',NULL,NULL,'T678','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T681','','','','','T854',NULL,NULL,'T681','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T685','','','','','T436',NULL,NULL,'T685','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T692','','','','','T835',NULL,NULL,'T692','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T690','','','','','T829',NULL,NULL,'T690','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T699','','','','','T445',NULL,NULL,'T699','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T698','','','','','T285',NULL,NULL,'T698','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T696','','','','','T436',NULL,NULL,'T696','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T701','','','','','T285',NULL,NULL,'T701','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T708','','','','','T861',NULL,NULL,'T708','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T710','','','','','T436',NULL,NULL,'T710','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T714','','','','','T285',NULL,NULL,'T714','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T718','','','','','T863',NULL,NULL,'T718','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T723','','','','','T436',NULL,NULL,'T723','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T720','','','','','T436',NULL,NULL,'T720','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T725','','','','','T436',NULL,NULL,'T725','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T728','','','','','T436',NULL,NULL,'T728','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T732','','','','','T436',NULL,NULL,'T732','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T735','','','','','T865',NULL,NULL,'T735','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T737','','','','','T815',NULL,NULL,'T737','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T739','','','','','T436',NULL,NULL,'T739','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T749','','','','','T866',NULL,NULL,'T749','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T754','','','','','T868',NULL,NULL,'T754','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T761','','','','','T436',NULL,NULL,'T761','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T758','','','','','T826',NULL,NULL,'T758','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T772','','','','','T436',NULL,NULL,'T772','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T770','','','','','T840',NULL,NULL,'T770','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T812','','','','','',NULL,NULL,'T812','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T813','','','','','',NULL,NULL,'T813','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T816','','','','','T817',NULL,NULL,'T816','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T817','','','','','',NULL,NULL,'T817','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T814','','','','','',NULL,NULL,'T814','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T815','','','','','T285',NULL,NULL,'T815','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T819','','','','','',NULL,NULL,'T819','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T823','','','','','',NULL,NULL,'T823','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T818','','','','','T819',NULL,NULL,'T818','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T821','','','','','',NULL,NULL,'T821','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T822','','','','','T823',NULL,NULL,'T822','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T824','','','','','T825',NULL,NULL,'T824','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T829','','','','','T825',NULL,NULL,'T829','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T830','','','','','T812',NULL,NULL,'T830','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T825','','','','','',NULL,NULL,'T825','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T827','','','','','',NULL,NULL,'T827','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T828','','','','','T285',NULL,NULL,'T828','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T826','','','','','T827',NULL,NULL,'T826','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T831','','','','','T832',NULL,NULL,'T831','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T836','','','','','T837',NULL,NULL,'T836','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T833','','','','','T817',NULL,NULL,'T833','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T835','','','','','T814',NULL,NULL,'T835','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T837','','','','','',NULL,NULL,'T837','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T838','','','','','T839',NULL,NULL,'T838','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T832','','','','','',NULL,NULL,'T832','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T834','','','','','T812',NULL,NULL,'T834','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T842','','','','','',NULL,NULL,'T842','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T843','','','','','T819',NULL,NULL,'T843','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T841','','','','','T842',NULL,NULL,'T841','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T839','','','','','',NULL,NULL,'T839','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T840','','','','','T825',NULL,NULL,'T840','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T844','','','','','T845',NULL,NULL,'T844','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T849','','','','','',NULL,NULL,'T849','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T847','','','','','T285',NULL,NULL,'T847','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T845','','','','','',NULL,NULL,'T845','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T848','','','','','T849',NULL,NULL,'T848','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T846','','','','','T814',NULL,NULL,'T846','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T850','','','','','T851',NULL,NULL,'T850','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T855','','','','','',NULL,NULL,'T855','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T851','','','','','T852',NULL,NULL,'T851','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T854','','','','','T855',NULL,NULL,'T854','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T856','','','','','T819',NULL,NULL,'T856','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T852','','','','','',NULL,NULL,'T852','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T859','','','','','T860',NULL,NULL,'T859','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T860','','','','','',NULL,NULL,'T860','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T857','','','','','',NULL,NULL,'T857','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T858','','','','','T285',NULL,NULL,'T858','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T863','','','','','T864',NULL,NULL,'T863','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T861','','','','','T862',NULL,NULL,'T861','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T862','','','','','',NULL,NULL,'T862','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T865','','','','','T823',NULL,NULL,'T865','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T866','','','','','T867',NULL,NULL,'T866','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T864','','','','','',NULL,NULL,'T864','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T869','','','','','',NULL,NULL,'T869','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T867','','','','','',NULL,NULL,'T867','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T868','','','','','T869',NULL,NULL,'T868','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T853','','','','','T848',NULL,NULL,'T853','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T873','','','','','',NULL,NULL,'T873','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T871','','','','','T872',NULL,NULL,'T871','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T875','','','','','T812',NULL,NULL,'T875','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T874','','','','','T875',NULL,NULL,'T874','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T870','','','','','T829',NULL,NULL,'T870','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T872','','','','','T873',NULL,NULL,'T872','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T879','','','','','',NULL,NULL,'T879','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T878','','','','','T879',NULL,NULL,'T878','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T881','','','','','T285',NULL,NULL,'T881','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T883','','','','','T884',NULL,NULL,'T883','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T876','','','','','T840',NULL,NULL,'T876','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T882','','','','','T883',NULL,NULL,'T882','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T877','','','','','T878',NULL,NULL,'T877','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T884','','','','','',NULL,NULL,'T884','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T880','','','','','T881',NULL,NULL,'T880','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T888','','','','','T812',NULL,NULL,'T888','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T886','','','','','T817',NULL,NULL,'T886','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T885','','','','','T886',NULL,NULL,'T885','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T892','','','','','T285',NULL,NULL,'T892','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T889','','','','','T861',NULL,NULL,'T889','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T887','','','','','T888',NULL,NULL,'T887','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T894','','','','','T873',NULL,NULL,'T894','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T891','','','','','T892',NULL,NULL,'T891','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T896','','','','','T869',NULL,NULL,'T896','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T898','','','','','T873',NULL,NULL,'T898','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T893','','','','','T894',NULL,NULL,'T893','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T890','','','','','T865',NULL,NULL,'T890','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T895','','','','','T896',NULL,NULL,'T895','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T899','','','','','T886',NULL,NULL,'T899','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T902','','','','','T161',NULL,NULL,'T902','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T897','','','','','T898',NULL,NULL,'T897','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T903','','','','','T875',NULL,NULL,'T903','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T900','','','','','T830',NULL,NULL,'T900','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T906','','','','','T161',NULL,NULL,'T906','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T905','','','','','T875',NULL,NULL,'T905','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO taxon VALUES('T907','','','','','T161',NULL,NULL,'T907','','','','','','','',NULL,'',NULL,'','','','','','','','','','','','','','','','','','','','','','','');
CREATE TABLE synonym (
  id TEXT, -- optional
  taxon_id TEXT NOT NULL REFERENCES taxon DEFAULT '',
  source_id TEXT REFERENCES source DEFAULT '',
  name_id TEXT NOT NULL REFERENCES name DEFAULT '',
  name_phrase TEXT DEFAULT '', -- annotation (eg `sensu lato` etc)
  according_to_id TEXT REFERENCES reference DEFAULT '',
  status_id TEXT REFERENCES taxonomic_status DEFAULT '',
  reference_id TEXT DEFAULT '', -- ids, sep by ',' about this synonym
  link TEXT DEFAULT '',
  remarks TEXT DEFAULT '',
  modified TEXT DEFAULT '',
  modified_by TEXT DEFAULT ''
) STRICT;
INSERT INTO synonym VALUES('T298','T003','','T298','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T297','T003','','T297','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T299','T003','','T299','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T005','T282','','T005','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T301','T010','','T301','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T300','T009','','T300','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T014','T900','','T014','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T303','T019','','T303','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T302','T019','','T302','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T304','T025','','T304','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T306','T027','','T306','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T307','T029','','T307','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T310','T029','','T310','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T309','T029','','T309','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T308','T029','','T308','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T313','T029','','T313','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T311','T029','','T311','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T312','T029','','T312','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T314','T029','','T314','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T315','T040','','T315','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T316','T047','','T316','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T317','T048','','T317','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T318','T048','','T318','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T320','T049','','T320','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T321','T049','','T321','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T323','T049','','T323','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T322','T049','','T322','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T324','T049','','T324','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T325','T052','','T325','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T326','T052','','T326','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T327','T053','','T327','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T053','T874','','T053','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T056','T492','','T056','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T328','T060','','T328','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T061','T874','','T061','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T063','T874','','T063','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T329','T062','','T329','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T330','T071','','T330','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T331','T071','','T331','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T332','T074','','T332','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T074','T900','','T074','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T333','T078','','T333','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T334','T081','','T334','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T079','T280','','T079','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T335','T087','','T335','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T336','T087','','T336','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T337','T087','','T337','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T339','T088','','T339','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T338','T087','','T338','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T340','T096','','T340','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T341','T096','','T341','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T343','T096','','T343','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T342','T096','','T342','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T345','T101','','T345','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T344','T098','','T344','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T346','T104','','T346','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T348','T105','','T348','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T347','T105','','T347','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T349','T106','','T349','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T350','T029','','T350','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T351','T118','','T351','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T117','T287','','T117','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T352','T120','','T352','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T354','T296','','T354','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T355','T123','','T355','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T356','T126','','T356','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T357','T127','','T357','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T359','T130','','T359','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T358','T130','','T358','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T340','T130','','T340','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T342','T130','','T342','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T343','T130','','T343','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T344','T131','','T344','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T341','T130','','T341','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T345','T139','','T345','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T138','T905','','T138','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T144','T029','','T144','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T146','T029','','T146','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T145','T029','','T145','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T147','T029','','T147','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T148','T043','','T148','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T149','T052','','T149','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T153','T096','','T153','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T150','T054','','T150','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T151','T492','','T151','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T155','T106','','T155','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T154','T105','','T154','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T152','T096','','T152','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T156','T110','','T156','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T157','T116','','T157','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T160','T141','','T160','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T164','T049','','T164','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T158','T287','','T158','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T165','T049','','T165','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T170','T167','','T170','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T168','T167','','T168','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T169','T167','','T169','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T166','T076','','T166','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T346','T172','','T346','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T347','T176','','T347','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T349','T178','','T349','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T348','T178','','T348','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T350','T179','','T350','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T351','T184','','T351','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T352','T187','','T352','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T182','T283','','T182','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T353','T191','','T353','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T193','T900','','T193','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T354','T197','','T354','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T198','T197','','T198','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T355','T199','','T355','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T356','T201','','T356','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T357','T201','','T357','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T358','T224','','T358','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T225','T224','','T225','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T236','T235','','T236','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T359','T240','','T359','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T239','T240','','T239','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T360','T241','','T360','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T361','T246','','T361','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T247','T277','','T247','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T251','T250','','T251','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T362','T250','','T362','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T253','T252','','T253','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T254','T252','','T254','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T365','T252','','T365','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T363','T252','','T363','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T367','T252','','T367','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T370','T252','','T370','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T369','T252','','T369','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T368','T252','','T368','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T371','T252','','T371','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T373','T252','','T373','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T372','T252','','T372','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T255','T287','','T255','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T256','T287','','T256','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T260','T259','','T260','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T375','T261','','T375','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T374','T261','','T374','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T376','T264','','T376','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T377','T272','','T377','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T378','T272','','T378','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T274','T273','','T274','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T379','T273','','T379','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T281','T280','','T281','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T223','T291','','T223','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T290','T291','','T290','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T295','T294','','T295','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T384','T383','','T384','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T382','T381','','T382','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T386','T385','','T386','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T390','T389','','T390','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T388','T387','','T388','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T393','T392','','T393','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T395','T394','','T395','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T399','T398','','T399','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T397','T396','','T397','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T404','T403','','T404','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T409','T408','','T409','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T406','T405','','T406','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T413','T412','','T413','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T417','T416','','T417','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T424','T423','','T424','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T422','T421','','T422','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T420','T419','','T420','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T429','T428','','T429','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T435','T870','','T435','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T434','T870','','T434','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T437','T291','','T437','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T433','T432','','T433','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T442','T439','','T442','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T440','T439','','T440','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T443','T871','','T443','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T444','T871','','T444','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T449','T451','','T449','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T450','T451','','T450','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T453','T452','','T453','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T454','T452','','T454','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T459','T458','','T459','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T456','T457','','T456','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T460','T458','','T460','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T464','T463','','T464','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T466','T465','','T466','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T471','T470','','T471','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T468','T467','','T468','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T472','T470','','T472','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T473','T470','','T473','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T475','T474','','T475','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T477','T476','','T477','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T478','T291','','T478','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T480','T479','','T480','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T481','T482','','T481','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T484','T483','','T484','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T487','T486','','T487','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T485','T483','','T485','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T488','T486','','T488','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T490','T874','','T490','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T491','T874','','T491','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T489','T874','','T489','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T493','T492','','T493','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T495','T494','','T495','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T499','T498','','T499','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T497','T496','','T497','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T501','T500','','T501','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T503','T502','','T503','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T507','T876','','T507','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T505','T504','','T505','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T508','T502','','T508','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T506','T876','','T506','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T509','T502','','T509','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T511','T510','','T511','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T513','T512','','T513','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T516','T515','','T516','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T517','','','T517','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T514','T512','','T514','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T519','','','T519','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T518','','','T518','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T521','T520','','T521','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T522','','','T522','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T524','T523','','T524','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T525','','','T525','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T527','T871','','T527','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T529','T528','','T529','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T526','T871','','T526','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T530','T528','','T530','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T533','T291','','T533','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T532','T531','','T532','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T534','T291','','T534','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T537','','','T537','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T535','T291','','T535','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T538','T539','','T538','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T541','T540','','T541','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T536','T291','','T536','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T544','T877','','T544','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T547','T546','','T547','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T545','T877','','T545','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T543','T287','','T543','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T549','T548','','T549','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T550','T465','','T550','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T553','T552','','T553','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T551','T465','','T551','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T554','T539','','T554','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T555','T539','','T555','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T556','T539','','T556','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T557','T546','','T557','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T559','T880','','T559','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T558','T880','','T558','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T560','T502','','T560','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T563','T562','','T563','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T561','','','T561','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T565','T564','','T565','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T566','T096','','T566','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T569','T568','','T569','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T567','','','T567','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T571','T570','','T571','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T572','T570','','T572','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T575','T574','','T575','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T573','','','T573','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T576','T574','','T576','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T579','T577','','T579','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T580','T577','','T580','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T578','T577','','T578','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T582','T476','','T582','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T581','T577','','T581','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T583','T476','','T583','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T588','T589','','T588','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T585','T584','','T585','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T586','T476','','T586','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T587','T476','','T587','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T590','','','T590','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T591','T492','','T591','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T592','T492','','T592','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T593','T492','','T593','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T595','T594','','T595','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T597','T882','','T597','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T599','T598','','T599','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T596','T882','','T596','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T601','T600','','T601','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T606','T874','','T606','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T603','T602','','T603','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T604','','','T604','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T605','T874','','T605','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T607','','','T607','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T608','','','T608','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T610','T609','','T610','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T615','T612','','T615','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T614','T612','','T614','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T613','T612','','T613','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T611','T546','','T611','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T616','','','T616','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T619','T476','','T619','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T618','T617','','T618','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T622','T885','','T622','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T621','T620','','T621','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T626','T612','','T626','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T624','T885','','T624','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T627','T612','','T627','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T623','T885','','T623','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T625','T612','','T625','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T629','T628','','T629','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T631','T630','','T631','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T633','T632','','T633','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T634','T632','','T634','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T635','T632','','T635','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T639','T853','','T639','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T640','T853','','T640','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T637','T636','','T637','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T638','T636','','T638','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T644','T643','','T644','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T645','T643','','T645','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T642','T641','','T642','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T646','T887','','T646','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T647','T887','','T647','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T648','T850','','T648','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T649','T850','','T649','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T651','T650','','T651','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T653','T652','','T653','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T654','T652','','T654','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T656','T655','','T656','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T660','T889','','T660','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T661','T889','','T661','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T658','T657','','T658','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T659','T889','','T659','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T663','T662','','T663','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T666','T665','','T666','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T668','T667','','T668','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T669','','','T669','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T664','T476','','T664','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T673','T672','','T673','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T671','T670','','T671','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T676','T675','','T676','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T674','T476','','T674','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T677','T675','','T677','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T679','T678','','T679','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T680','T678','','T680','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T682','T681','','T682','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T684','T681','','T684','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T686','T685','','T686','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T683','T681','','T683','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T688','T291','','T688','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T687','T492','','T687','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T689','T291','','T689','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T693','T692','','T693','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T691','T690','','T691','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T694','T681','','T694','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T695','T692','','T695','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T697','T696','','T697','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T700','T699','','T700','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T705','T891','','T705','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T703','T890','','T703','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T702','T890','','T702','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T706','T707','','T706','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T704','T891','','T704','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T707','','','T707','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T709','T708','','T709','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T711','T710','','T711','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T713','T636','','T713','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T712','T636','','T712','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T716','T476','','T716','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T717','T476','','T717','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T715','','','T715','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T719','T718','','T719','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T721','T720','','T721','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T722','T498','','T722','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T724','T723','','T724','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T727','T667','','T727','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T726','T725','','T726','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T729','T728','','T729','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T731','T287','','T731','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T730','T287','','T730','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T733','T732','','T733','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T734','T636','','T734','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T736','T735','','T736','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T738','T737','','T738','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T740','T739','','T740','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T741','T739','','T741','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T743','T739','','T743','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T744','T539','','T744','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T745','T893','','T745','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T746','T893','','T746','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T742','T739','','T742','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T748','T594','','T748','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T750','T749','','T750','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T747','T476','','T747','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T752','T895','','T752','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T751','','','T751','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T755','T754','','T755','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T753','T895','','T753','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T756','T897','','T756','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T760','T758','','T760','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T757','T897','','T757','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T759','T758','','T759','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T762','T761','','T762','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T763','T476','','T763','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T764','','','T764','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T767','T476','','T767','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T765','T546','','T765','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T766','T546','','T766','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T768','','','T768','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T771','','','T771','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T769','T770','','T769','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T773','T772','','T773','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T774','T770','','T774','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T778','T291','','T778','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T777','T899','','T777','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T780','T670','','T780','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T775','','','T775','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T776','T899','','T776','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T779','T476','','T779','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T781','','','T781','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T783','','','T783','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T782','','','T782','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T786','','','T786','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T785','','','T785','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T787','','','T787','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T784','','','T784','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T790','','','T790','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T788','','','T788','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T789','','','T789','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T792','','','T792','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T793','','','T793','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T791','','','T791','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T795','','','T795','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T796','','','T796','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T794','','','T794','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T797','','','T797','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T799','','','T799','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T798','','','T798','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T802','','','T802','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T801','','','T801','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T800','','','T800','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T804','','','T804','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T805','','','T805','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T803','','','T803','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T806','','','T806','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T809','','','T809','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T808','','','T808','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T807','','','T807','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T810','','','T810','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T811','','','T811','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T901','T900','','T901','','','SYNONYM','','','','','');
INSERT INTO synonym VALUES('T904','T903','','T904','','','SYNONYM','','','','','');
CREATE TABLE vernacular (
  taxon_id TEXT NOT NULL REFERENCES taxon DEFAULT '',
  source_id TEXT REFERENCES source DEFAULT '',
  name TEXT NOT NULL,
  transliteration TEXT DEFAULT '',
  language TEXT DEFAULT '',
  preferred INTEGER DEFAULT NULL, -- bool
  country TEXT DEFAULT '',
  area TEXT DEFAULT '',
  sex_id TEXT REFERENCES sex DEFAULT '',
  reference_id TEXT REFERENCES reference DEFAULT '',
  remarks TEXT DEFAULT '',
  modified TEXT DEFAULT '',
  modified_by TEXT DEFAULT ''
) STRICT;
CREATE TABLE name_relation (
  name_id TEXT NOT NULL REFERENCES name DEFAULT '',
  related_name_id TEXT NOT NULL REFERENCES name DEFAULT '',
  source_id TEXT REFERENCES source,
  -- nom_rel_type enum
  type_id TEXT NOT NULL REFERENCES nom_rel_type DEFAULT '',
  -- starting page number for the nomenclatural event
  page TEXT DEFAULT '',
  reference_id TEXT REFERENCES reference DEFAULT '',
  remarks TEXT DEFAULT '',
  modified TEXT DEFAULT '',
  modified_by TEXT DEFAULT ''
) STRICT;
CREATE TABLE type_material (
  id TEXT DEFAULT '', -- optional
  source_id TEXT REFERENCES source DEFAULT '',
  name_id TEXT NOT NULL REFERENCES name DEFAULT '',
  citation TEXT DEFAULT '',
  status_id TEXT REFERENCES type_status DEFAULT '',
  institution_code TEXT DEFAULT '',
  catalog_number TEXT DEFAULT '',
  reference_id TEXT REFERENCES reference DEFAULT '',
  locality TEXT DEFAULT '',
  country TEXT DEFAULT '',
  latitude REAL DEFAULT 0,
  longitude REAL DEFAULT 0,
  altitude int DEFAULT 0,
  host TEXT DEFAULT '',
  sex_id TEXT REFERENCES sex DEFAULT '',
  date TEXT DEFAULT '',
  collector TEXT DEFAULT '',
  associated_sequences TEXT DEFAULT '',
  link TEXT DEFAULT '',
  remarks TEXT DEFAULT '',
  modified TEXT DEFAULT '',
  modified_by TEXT DEFAULT ''
) STRICT;
CREATE TABLE distribution (
  taxon_id TEXT NOT NULL REFERENCES taxon DEFAULT '',
  source_id TEXT REFERENCES source DEFAULT '',
  area TEXT DEFAULT '',
  area_id TEXT DEFAULT '',
  gazetteer_id TEXT REFERENCES gazetteer DEFAULT '',
  status_id TEXT REFERENCES distribution_status DEFAULT '',
  reference_id TEXT REFERENCES reference DEFAULT '',
  remarks TEXT DEFAULT '',
  modified TEXT DEFAULT '',
  modified_by TEXT DEFAULT ''
) STRICT;
CREATE TABLE media (
  taxon_id TEXT NOT NULL REFERENCES taxon DEFAULT '',
  source_id TEXT REFERENCES source DEFAULT '',
  url TEXT NOT NULL, -- in CoLDP media is always a link
  type TEXT DEFAULT '', -- MIME type
  format TEXT DEFAULT '',
  title TEXT DEFAULT '',
  created TEXT DEFAULT '',
  creator TEXT DEFAULT '',
  license TEXT DEFAULT '',
  link TEXT DEFAULT '',
  remarks TEXT DEFAULT '',
  modified TEXT DEFAULT '',
  modified_by TEXT DEFAULT ''
) STRICT;
CREATE TABLE treatment (
  taxon_id TEXT NOT NULL REFERENCES taxon DEFAULT '',
  source_id TEXT REFERENCES source DEFAULT '',
  document TEXT NOT NULL,
  format TEXT DEFAULT '', -- HTML, XML, TXT
  modified TEXT DEFAULT '',
  modified_by TEXT DEFAULT ''
) STRICT;
CREATE TABLE species_estimate (
  taxon_id TEXT NOT NULL REFERENCES taxon DEFAULT '',
  source_id TEXT REFERENCES source DEFAULT '',
  estimate INTEGER NOT NULL, -- estimated number of species
  type TEXT NOT NULL REFERENCES estimate_type DEFAULT '',
  reference_id TEXT REFERENCES reference DEFAULT '',
  remarks TEXT DEFAULT '',
  modified TEXT DEFAULT '',
  modified_by TEXT DEFAULT ''
) STRICT;
CREATE TABLE taxon_property (
  taxon_id TEXT NOT NULL REFERENCES taxon DEFAULT '',
  source_id TEXT REFERENCES source DEFAULT '',
  property TEXT NOT NULL, -- name of the property
  value TEXT NOT NULL,
  reference_id TEXT REFERENCES reference DEFAULT '',
  page TEXT DEFAULT '',
  ordinal INTEGER DEFAULT NULL, -- sorting value
  remarks TEXT DEFAULT '',
  modified TEXT DEFAULT '',
  modified_by TEXT DEFAULT ''
) STRICT;
CREATE TABLE species_interaction (
  taxon_id TEXT NOT NULL REFERENCES taxon DEFAULT '',
  related_taxon_id TEXT NOT NULL REFERENCES taxon DEFAULT '',
  source_id TEXT REFERENCES source DEFAULT '',
  related_taxon_scientific_name TEXT DEFAULT '', -- id or hardcoded name?
  type TEXT NOT NULL REFERENCES species_interaction_type DEFAULT '',
  reference_id TEXT REFERENCES reference DEFAULT '',
  remarks TEXT DEFAULT '',
  modified TEXT DEFAULT '',
  modified_by TEXT DEFAULT ''
) STRICT;
CREATE TABLE taxon_concept_relation (
  taxon_id TEXT NOT NULL REFERENCES taxon DEFAULT '',
  related_taxon_id TEXT NOT NULL REFERENCES taxon DEFAULT '',
  source_id TEXT REFERENCES source DEFAULT '',
  type TEXT REFERENCES taxon_concept_rel_type DEFAULT '',
  reference_id TEXT REFERENCES reference DEFAULT '',
  remarks TEXT DEFAULT '',
  modified TEXT DEFAULT '',
  modified_by TEXT DEFAULT ''
) STRICT;
CREATE TABLE nom_code (id TEXT PRIMARY KEY) STRICT;
INSERT INTO nom_code VALUES('');
INSERT INTO nom_code VALUES('BACTERIAL');
INSERT INTO nom_code VALUES('BOTANICAL');
INSERT INTO nom_code VALUES('CULTIVARS');
INSERT INTO nom_code VALUES('PHYTOSOCIOLOGICAL');
INSERT INTO nom_code VALUES('VIRUS');
INSERT INTO nom_code VALUES('ZOOLOGICAL');
CREATE TABLE name_part (id TEXT PRIMARY KEY) STRICT;
INSERT INTO name_part VALUES('');
INSERT INTO name_part VALUES('GENERIC');
INSERT INTO name_part VALUES('INFRAGENERIC');
INSERT INTO name_part VALUES('SPECIFIC');
INSERT INTO name_part VALUES('INFRASPECIFIC');
CREATE TABLE gender (id TEXT PRIMARY KEY) STRICT;
INSERT INTO gender VALUES('');
INSERT INTO gender VALUES('MASCULINE');
INSERT INTO gender VALUES('FEMININE');
INSERT INTO gender VALUES('NEUTRAL');
CREATE TABLE sex (id TEXT PRIMARY KEY) STRICT;
INSERT INTO sex VALUES('');
INSERT INTO sex VALUES('MALE');
INSERT INTO sex VALUES('FEMALE');
INSERT INTO sex VALUES('HERMAPHRODITE');
CREATE TABLE estimate_type (id TEXT PRIMARY KEY) STRICT;
INSERT INTO estimate_type VALUES('');
INSERT INTO estimate_type VALUES('SPECIES_EXTINCT');
INSERT INTO estimate_type VALUES('SPECIES_LIVING');
INSERT INTO estimate_type VALUES('ESTIMATED_SPECIES');
CREATE TABLE distribution_status (id TEXT PRIMARY KEY) STRICT;
INSERT INTO distribution_status VALUES('');
INSERT INTO distribution_status VALUES('NATIVE');
INSERT INTO distribution_status VALUES('DOMESTICATED');
INSERT INTO distribution_status VALUES('ALIEN');
INSERT INTO distribution_status VALUES('UNCERTAIN');
CREATE TABLE type_status (
  id TEXT PRIMARY KEY,
  name TEXT,
  root TEXT REFERENCES type_status,
  "primary" INTEGER, -- bool
  codes TEXT -- nom codes sep ',' 
) STRICT;
INSERT INTO type_status VALUES('','','',0,'');
INSERT INTO type_status VALUES('OTHER','other','OTHER',0,'');
INSERT INTO type_status VALUES('HOMOEOTYPE','homoeotype','HOMOEOTYPE',0,'ZOOLOGICAL');
INSERT INTO type_status VALUES('PLESIOTYPE','plesiotype','PLESIOTYPE',0,'ZOOLOGICAL');
INSERT INTO type_status VALUES('PLASTOTYPE','plastotype','PLASTOTYPE',0,'BOTANICAL,ZOOLOGICAL');
INSERT INTO type_status VALUES('PLASTOSYNTYPE','plastosyntype','SYNTYPE',0,'BOTANICAL,ZOOLOGICAL');
INSERT INTO type_status VALUES('PLASTOPARATYPE','plastoparatype','PARATYPE',0,'BOTANICAL,ZOOLOGICAL');
INSERT INTO type_status VALUES('PLASTONEOTYPE','plastoneotype','NEOTYPE',0,'');
INSERT INTO type_status VALUES('PLASTOLECTOTYPE','plastolectotype','LECTOTYPE',0,'');
INSERT INTO type_status VALUES('PLASTOISOTYPE','plastoisotype','HOLOTYPE',0,'');
INSERT INTO type_status VALUES('PLASTOHOLOTYPE','plastoholotype','HOLOTYPE',0,'');
INSERT INTO type_status VALUES('ALLOTYPE','allotype','PARATYPE',0,'ZOOLOGICAL');
INSERT INTO type_status VALUES('ALLONEOTYPE','alloneotype','NEOTYPE',0,'ZOOLOGICAL');
INSERT INTO type_status VALUES('ALLOLECTOTYPE','allolectotype','LECTOTYPE',0,'ZOOLOGICAL');
INSERT INTO type_status VALUES('PARANEOTYPE','paraneotype','NEOTYPE',0,'ZOOLOGICAL');
INSERT INTO type_status VALUES('PARALECTOTYPE','paralectotype','LECTOTYPE',0,'ZOOLOGICAL');
INSERT INTO type_status VALUES('ISOSYNTYPE','isosyntype','SYNTYPE',0,'BOTANICAL');
INSERT INTO type_status VALUES('ISOPARATYPE','isoparatype','PARATYPE',0,'BOTANICAL');
INSERT INTO type_status VALUES('ISONEOTYPE','isoneotype','NEOTYPE',0,'BOTANICAL');
INSERT INTO type_status VALUES('ISOLECTOTYPE','isolectotype','LECTOTYPE',0,'BOTANICAL');
INSERT INTO type_status VALUES('ISOEPITYPE','isoepitype','EPITYPE',0,'BOTANICAL');
INSERT INTO type_status VALUES('ISOTYPE','isotype','HOLOTYPE',0,'BOTANICAL');
INSERT INTO type_status VALUES('TOPOTYPE','topotype','TOPOTYPE',0,'BOTANICAL,ZOOLOGICAL');
INSERT INTO type_status VALUES('SYNTYPE','syntype','SYNTYPE',1,'BOTANICAL,ZOOLOGICAL');
INSERT INTO type_status VALUES('PATHOTYPE','pathotype','PATHOTYPE',0,'BACTERIAL');
INSERT INTO type_status VALUES('PARATYPE','paratype','PARATYPE',1,'BOTANICAL,ZOOLOGICAL');
INSERT INTO type_status VALUES('ORIGINAL_MATERIAL','original material','ORIGINAL_MATERIAL',1,'BOTANICAL');
INSERT INTO type_status VALUES('NEOTYPE','neotype','NEOTYPE',1,'BACTERIAL,BOTANICAL,ZOOLOGICAL');
INSERT INTO type_status VALUES('LECTOTYPE','lectotype','LECTOTYPE',1,'BACTERIAL,BOTANICAL,ZOOLOGICAL');
INSERT INTO type_status VALUES('ICONOTYPE','iconotype','ICONOTYPE',0,'BOTANICAL');
INSERT INTO type_status VALUES('HOLOTYPE','holotype','HOLOTYPE',1,'BACTERIAL,BOTANICAL,ZOOLOGICAL');
INSERT INTO type_status VALUES('HAPANTOTYPE','hapantotype','HAPANTOTYPE',0,'ZOOLOGICAL');
INSERT INTO type_status VALUES('EX_TYPE','ex type','EX_TYPE',0,'BOTANICAL,ZOOLOGICAL');
INSERT INTO type_status VALUES('ERGATOTYPE','ergatotype','ERGATOTYPE',0,'ZOOLOGICAL');
INSERT INTO type_status VALUES('EPITYPE','epitype','EPITYPE',0,'BOTANICAL');
CREATE TABLE nom_rel_type (id TEXT PRIMARY KEY) STRICT;
INSERT INTO nom_rel_type VALUES('');
INSERT INTO nom_rel_type VALUES('SPELLING_CORRECTION');
INSERT INTO nom_rel_type VALUES('BASIONYM');
INSERT INTO nom_rel_type VALUES('BASEDON');
INSERT INTO nom_rel_type VALUES('REPLACEMENT_NAME');
INSERT INTO nom_rel_type VALUES('CONSERVED');
INSERT INTO nom_rel_type VALUES('LATER_HOMONYM');
INSERT INTO nom_rel_type VALUES('SUPERFLUOUS');
INSERT INTO nom_rel_type VALUES('HOMOTYPIC');
INSERT INTO nom_rel_type VALUES('TYPE');
CREATE TABLE nom_status (id TEXT PRIMARY KEY) STRICT;
INSERT INTO nom_status VALUES('');
INSERT INTO nom_status VALUES('ESTABLISHED');
INSERT INTO nom_status VALUES('ACCEPTABLE');
INSERT INTO nom_status VALUES('UNACCEPTABLE');
INSERT INTO nom_status VALUES('CONSERVED');
INSERT INTO nom_status VALUES('REJECTED');
INSERT INTO nom_status VALUES('DOUBTFUL');
INSERT INTO nom_status VALUES('MANUSCRIPT');
INSERT INTO nom_status VALUES('CHRESONYM');
CREATE TABLE reference_type(id TEXT PRIMARY KEY) STRICT;
INSERT INTO reference_type VALUES('');
INSERT INTO reference_type VALUES('ARTICLE');
INSERT INTO reference_type VALUES('ARTICLE_JOURNAL');
INSERT INTO reference_type VALUES('ARTICLE_MAGAZINE');
INSERT INTO reference_type VALUES('ARTICLE_NEWSPAPER');
INSERT INTO reference_type VALUES('BILL');
INSERT INTO reference_type VALUES('BOOK');
INSERT INTO reference_type VALUES('BROADCAST');
INSERT INTO reference_type VALUES('CHAPTER');
INSERT INTO reference_type VALUES('DATASET');
INSERT INTO reference_type VALUES('ENTRY');
INSERT INTO reference_type VALUES('ENTRY_DICTIONARY');
INSERT INTO reference_type VALUES('ENTRY_ENCYCLOPEDIA');
INSERT INTO reference_type VALUES('FIGURE');
INSERT INTO reference_type VALUES('GRAPHIC');
INSERT INTO reference_type VALUES('INTERVIEW');
INSERT INTO reference_type VALUES('LEGAL_CASE');
INSERT INTO reference_type VALUES('LEGISLATION');
INSERT INTO reference_type VALUES('MANUSCRIPT');
INSERT INTO reference_type VALUES('MAP');
INSERT INTO reference_type VALUES('MOTION_PICTURE');
INSERT INTO reference_type VALUES('MUSICAL_SCORE');
INSERT INTO reference_type VALUES('PAMPHLET');
INSERT INTO reference_type VALUES('PAPER_CONFERENCE');
INSERT INTO reference_type VALUES('PATENT');
INSERT INTO reference_type VALUES('PERSONAL_COMMUNICATION');
INSERT INTO reference_type VALUES('POST');
INSERT INTO reference_type VALUES('POST_WEBLOG');
INSERT INTO reference_type VALUES('REPORT');
INSERT INTO reference_type VALUES('REVIEW');
INSERT INTO reference_type VALUES('REVIEW_BOOK');
INSERT INTO reference_type VALUES('SONG');
INSERT INTO reference_type VALUES('SPEECH');
INSERT INTO reference_type VALUES('THESIS');
INSERT INTO reference_type VALUES('TREATY');
INSERT INTO reference_type VALUES('WEBPAGE');
CREATE TABLE taxonomic_status (
  id TEXT PRIMARY KEY,
  value TEXT DEFAULT '',
  name TEXT DEFAULT '',
  bare_name INTEGER DEFAULT 0, -- bool
  description TEXT DEFAULT '',
  majorStatus TEXT DEFAULT '',
  synonym INTEGER DEFAULT 0, -- bool
  taxon INTEGER DEFAULT 0 -- bool
) STRICT;
INSERT INTO taxonomic_status VALUES('','','',0,'','',0,0);
INSERT INTO taxonomic_status VALUES('ACCEPTED','','accepted',0,'A taxonomically accepted, current name','ACCEPTED',0,1);
INSERT INTO taxonomic_status VALUES('PROVISIONALLY_ACCEPTED','','provisionally accepted',0,'Treated as accepted, but doubtful whether this is correct.','ACCEPTED',0,1);
INSERT INTO taxonomic_status VALUES('SYNONYM','','synonym',0,'Names which point unambiguously at one species (not specifying whether homo- or heterotypic).Synonyms, in the CoL sense, include also orthographic variants and published misspellings.','SYNONYM',1,0);
INSERT INTO taxonomic_status VALUES('AMBIGUOUS_SYNONYM','','ambiguous synonym',0,'Names which are ambiguous because they point at the current species and one or more others e.g. homonyms, pro-parte synonyms (in other words, names which appear more than in one place in the Catalogue).','SYNONYM',1,0);
INSERT INTO taxonomic_status VALUES('MISAPPLIED','','misapplied',0,'A misapplied name. Usually accompanied with an accordingTo on the synonym to indicate the source the misapplication can be found in.','SYNONYM',1,0);
INSERT INTO taxonomic_status VALUES('BARE_NAME','','bare name',1,'A name alone without any usage, neither a synonym nor a taxon.','BARE_NAME',0,0);
CREATE TABLE species_interaction_type (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  inverse TEXT REFERENCES species_interaction_type,
  superTypes TEXT DEFAULT '', -- ids sep ','
  obo TEXT DEFAULT '',
  symmetrical INTEGER DEFAULT 0, -- bool
  description TEXT DEFAULT ''
);
INSERT INTO species_interaction_type VALUES('','','','','',0,'');
INSERT INTO species_interaction_type VALUES('MUTUALIST_OF','mutualist of','MUTUALIST_OF','SYMBIONT_OF','http://purl.obolibrary.org/obo/RO_0002442',1,'An interaction relationship between two organisms living together in more or less intimate association in a relationship in which both organisms benefit from each other (GO).');
INSERT INTO species_interaction_type VALUES('COMMENSALIST_OF','commensalist of','COMMENSALIST_OF','SYMBIONT_OF','http://purl.obolibrary.org/obo/RO_0002441',1,'An interaction relationship between two organisms living together in more or less intimate association in a relationship in which one benefits and the other is unaffected (GO).');
INSERT INTO species_interaction_type VALUES('HAS_EPIPHYTE','has epiphyte','EPIPHYTE_OF','SYMBIONT_OF','http://purl.obolibrary.org/obo/RO_0008502',0,'Inverse of epiphyte of');
INSERT INTO species_interaction_type VALUES('EPIPHYTE_OF','epiphyte of','HAS_EPIPHYTE','SYMBIONT_OF','http://purl.obolibrary.org/obo/RO_0008501',0,'An interaction relationship wherein a plant or algae is living on the outside surface of another plant.');
INSERT INTO species_interaction_type VALUES('HAS_EGGS_LAYED_ON_BY','has eggs layed on by','LAYS_EGGS_ON','HOST_OF','http://purl.obolibrary.org/obo/RO_0008508',0,'Inverse of lays eggs on');
INSERT INTO species_interaction_type VALUES('LAYS_EGGS_ON','lays eggs on','HAS_EGGS_LAYED_ON_BY','HAS_HOST','http://purl.obolibrary.org/obo/RO_0008507',0,'An interaction relationship in which organism a lays eggs on the outside surface of organism b. Organism b is neither helped nor harmed in the process of egg laying or incubation.');
INSERT INTO species_interaction_type VALUES('POLLINATED_BY','pollinated by','POLLINATES','FLOWERS_VISITED_BY','http://purl.obolibrary.org/obo/RO_0002456',0,'Inverse of pollinates');
INSERT INTO species_interaction_type VALUES('POLLINATES','pollinates','POLLINATED_BY','VISITS_FLOWERS_OF','http://purl.obolibrary.org/obo/RO_0002455',0,'This relation is intended to be used for biotic pollination - e.g. a bee pollinating a flowering plant. ');
INSERT INTO species_interaction_type VALUES('FLOWERS_VISITED_BY','flowers visited by','VISITS_FLOWERS_OF','VISITED_BY','http://purl.obolibrary.org/obo/RO_0002623',0,'Inverse of visits flowers of');
INSERT INTO species_interaction_type VALUES('VISITS_FLOWERS_OF','visits flowers of','FLOWERS_VISITED_BY','VISITS','http://purl.obolibrary.org/obo/RO_0002622',0,'');
INSERT INTO species_interaction_type VALUES('VISITED_BY','visited by','VISITS','HOST_OF','http://purl.obolibrary.org/obo/RO_0002619',0,'Inverse of visits');
INSERT INTO species_interaction_type VALUES('VISITS','visits','VISITED_BY','HAS_HOST','http://purl.obolibrary.org/obo/RO_0002618',0,'');
INSERT INTO species_interaction_type VALUES('HAS_HYPERPARASITOID','has hyperparasitoid','HYPERPARASITOID_OF','HAS_PARASITOID','http://purl.obolibrary.org/obo/RO_0002554',0,'Inverse of hyperparasitoid of');
INSERT INTO species_interaction_type VALUES('HYPERPARASITOID_OF','hyperparasitoid of','HAS_HYPERPARASITOID','PARASITOID_OF','http://purl.obolibrary.org/obo/RO_0002553',0,'X is a hyperparasite of y if x is a parasite of a parasite of the target organism y');
INSERT INTO species_interaction_type VALUES('HAS_PARASITOID','has parasitoid','PARASITOID_OF','HAS_PARASITE','http://purl.obolibrary.org/obo/RO_0002209',0,'Inverse of parasitoid of');
INSERT INTO species_interaction_type VALUES('PARASITOID_OF','parasitoid of','HAS_PARASITOID','PARASITE_OF','http://purl.obolibrary.org/obo/RO_0002208',0,'A parasite that kills or sterilizes its host');
INSERT INTO species_interaction_type VALUES('HAS_KLEPTOPARASITE','has kleptoparasite','KLEPTOPARASITE_OF','HAS_PARASITE','http://purl.obolibrary.org/obo/RO_0008503',0,'Inverse of kleptoparasite of');
INSERT INTO species_interaction_type VALUES('KLEPTOPARASITE_OF','kleptoparasite of','HAS_KLEPTOPARASITE','PARASITE_OF','http://purl.obolibrary.org/obo/RO_0008503',0,'A sub-relation of parasite of in which a parasite steals resources from another organism, usually food or nest material');
INSERT INTO species_interaction_type VALUES('HAS_HYPERPARASITE','has hyperparasite','HYPERPARASITE_OF','HAS_PARASITE','http://purl.obolibrary.org/obo/RO_0002554',0,'Inverse of hyperparasite of');
INSERT INTO species_interaction_type VALUES('HYPERPARASITE_OF','hyperparasite of','HAS_HYPERPARASITE','PARASITE_OF','http://purl.obolibrary.org/obo/RO_0002553',0,'X is a hyperparasite of y iff x is a parasite of a parasite of the target organism y');
INSERT INTO species_interaction_type VALUES('HAS_ECTOPARASITE','has ectoparasite','ECTOPARASITE_OF','HAS_PARASITE','http://purl.obolibrary.org/obo/RO_0002633',0,'Inverse of ectoparasite of');
INSERT INTO species_interaction_type VALUES('ECTOPARASITE_OF','ectoparasite of','HAS_ECTOPARASITE','PARASITE_OF','http://purl.obolibrary.org/obo/RO_0002632',0,'A sub-relation of parasite-of in which the parasite lives on or in the integumental system of the host');
INSERT INTO species_interaction_type VALUES('HAS_ENDOPARASITE','has endoparasite','ENDOPARASITE_OF','HAS_PARASITE','http://purl.obolibrary.org/obo/RO_0002635',0,'Inverse of endoparasite of');
INSERT INTO species_interaction_type VALUES('ENDOPARASITE_OF','endoparasite of','HAS_ENDOPARASITE','PARASITE_OF','http://purl.obolibrary.org/obo/RO_0002634',0,'A sub-relation of parasite-of in which the parasite lives inside the host, beneath the integumental system');
INSERT INTO species_interaction_type VALUES('HAS_VECTOR','has vector','VECTOR_OF','HAS_HOST','http://purl.obolibrary.org/obo/RO_0002460',0,'Inverse of vector of');
INSERT INTO species_interaction_type VALUES('VECTOR_OF','vector of','HAS_VECTOR','HOST_OF','http://purl.obolibrary.org/obo/RO_0002459',0,'a is a vector for b if a carries and transmits an infectious pathogen b into another living organism');
INSERT INTO species_interaction_type VALUES('HAS_PATHOGEN','has pathogen','PATHOGEN_OF','HAS_PARASITE','http://purl.obolibrary.org/obo/RO_0002557',0,'Inverse of pathogen of');
INSERT INTO species_interaction_type VALUES('PATHOGEN_OF','pathogen of','HAS_PATHOGEN','PARASITE_OF','http://purl.obolibrary.org/obo/RO_0002556',0,'');
INSERT INTO species_interaction_type VALUES('HAS_PARASITE','has parasite','PARASITE_OF','EATEN_BY,HOST_OF','http://purl.obolibrary.org/obo/RO_0002445',0,'Inverse of parasite of');
INSERT INTO species_interaction_type VALUES('PARASITE_OF','parasite of','HAS_PARASITE','EATS,HAS_HOST','http://purl.obolibrary.org/obo/RO_0002444',0,'');
INSERT INTO species_interaction_type VALUES('HAS_HOST','has host','HOST_OF','SYMBIONT_OF','http://purl.obolibrary.org/obo/RO_0002454',0,'Inverse of host of');
INSERT INTO species_interaction_type VALUES('HOST_OF','host of','HAS_HOST','SYMBIONT_OF','http://purl.obolibrary.org/obo/RO_0002453',0,'The term host is usually used for the larger (macro) of the two members of a symbiosis');
INSERT INTO species_interaction_type VALUES('PREYED_UPON_BY','preyed upon by','PREYS_UPON','EATEN_BY,KILLED_BY','http://purl.obolibrary.org/obo/RO_0002458',0,'Inverse of preys upon');
INSERT INTO species_interaction_type VALUES('PREYS_UPON','preys upon','PREYED_UPON_BY','EATS,KILLS','http://purl.obolibrary.org/obo/RO_0002439',0,'An interaction relationship involving a predation process, where the subject kills the object in order to eat it or to feed to siblings, offspring or group members');
INSERT INTO species_interaction_type VALUES('KILLED_BY','killed by','KILLS','INTERACTS_WITH','http://purl.obolibrary.org/obo/RO_0002627',0,'Inverse of kills');
INSERT INTO species_interaction_type VALUES('KILLS','kills','KILLED_BY','INTERACTS_WITH','http://purl.obolibrary.org/obo/RO_0002626',0,'');
INSERT INTO species_interaction_type VALUES('EATEN_BY','eaten by','EATS','INTERACTS_WITH','http://purl.obolibrary.org/obo/RO_0002471',0,'Inverse of eats');
INSERT INTO species_interaction_type VALUES('EATS','eats','EATEN_BY','INTERACTS_WITH','http://purl.obolibrary.org/obo/RO_0002470',0,'Herbivores, fungivores, predators or other forms of organims eating or feeding on the related taxon.');
INSERT INTO species_interaction_type VALUES('SYMBIONT_OF','symbiont of','SYMBIONT_OF','INTERACTS_WITH','http://purl.obolibrary.org/obo/RO_0002440',1,'A symbiotic relationship, a more or less intimate association, with another organism. The various forms of symbiosis include parasitism, in which the association is disadvantageous or destructive to one of the organisms; mutualism, in which the association is advantageous, or often necessary to one or both and not harmful to either; and commensalism, in which one member of the association benefits while the other is not affected. However, mutualism, parasitism, and commensalism are often not discrete categories of interactions and should rather be perceived as a continuum of interaction ranging from parasitism to mutualism. In fact, the direction of a symbiotic interaction can change during the lifetime of the symbionts due to developmental changes as well as changes in the biotic/abiotic environment in which the interaction occurs. ');
INSERT INTO species_interaction_type VALUES('ADJACENT_TO','adjacent to','ADJACENT_TO','CO_OCCURS_WITH','http://purl.obolibrary.org/obo/RO_0002220',1,'X adjacent to y if and only if x and y share a boundary.');
INSERT INTO species_interaction_type VALUES('INTERACTS_WITH','interacts with','INTERACTS_WITH','CO_OCCURS_WITH','http://purl.obolibrary.org/obo/RO_0002437',1,'An interaction relationship in which at least one of the partners is an organism and the other is either an organism or an abiotic entity with which the organism interacts.');
INSERT INTO species_interaction_type VALUES('CO_OCCURS_WITH','co occurs with','CO_OCCURS_WITH','RELATED_TO','http://purl.obolibrary.org/obo/RO_0008506',1,'An interaction relationship describing organisms that often occur together at the same time and space or in the same environment.');
INSERT INTO species_interaction_type VALUES('RELATED_TO','related to','RELATED_TO','','http://purl.obolibrary.org/obo/RO_0002321',1,'Ecologically related to');
CREATE TABLE taxon_concept_rel_type (
  id TEXT PRIMARY KEY,
  name TEXT DEFAULT '',
  rcc5 TEXT DEFAULT '',
  description TEXT
) STRICT;
INSERT INTO taxon_concept_rel_type VALUES('','','','');
INSERT INTO taxon_concept_rel_type VALUES('EQUALS','equals','equal (EQ)','The circumscription of this taxon is (essentially) identical to the related taxon.');
INSERT INTO taxon_concept_rel_type VALUES('INCLUDES','includes','proper part inverse (PPi)','The related taxon concept is a subset of this taxon concept.');
INSERT INTO taxon_concept_rel_type VALUES('INCLUDED_IN','included in','proper part (PP)','This taxon concept is a subset of the related taxon concept.');
INSERT INTO taxon_concept_rel_type VALUES('OVERLAPS','overlaps','partially overlapping (PO)','Both taxon concepts share some members/children in common, and each contain some members not shared with the other.');
INSERT INTO taxon_concept_rel_type VALUES('EXCLUDES','excludes','disjoint (DR)','The related taxon concept is not a subset of this concept.');
CREATE TABLE gazetteer(
  id TEXT PRIMARY KEY,
  name TEXT,
  title TEXT,
  link TEXT,
  areaLinkTemplate TEXT,
  description TEXT
) STRICT;
INSERT INTO gazetteer VALUES('','','','','','');
INSERT INTO gazetteer VALUES('TDWG','tdwg','World Geographical Scheme for Recording Plant Distributions','http://www.tdwg.org/standards/109','','World Geographical Scheme for Recording Plant Distributions published by TDWG at level 1, 2, 3 or 4.  Level 1 = Continents, Level 2 = Regions, Level 3 = Botanical countries, Level 4 = Basic recording units.');
INSERT INTO gazetteer VALUES('ISO','iso','ISO 3166 Country Codes','https://en.wikipedia.org/wiki/ISO_3166','https://www.iso.org/obp/ui/#iso:code:3166:','ISO 3166 codes for the representation of names of countries and their subdivisions. Codes for current countries (ISO 3166-1), country subdivisions (ISO 3166-2) and formerly used names of countries (ISO 3166-3). Country codes can be given either as alpha-2, alpha-3 or numeric codes.');
INSERT INTO gazetteer VALUES('FAO','fao','FAO Major Fishing Areas','http://www.fao.org/fishery/cwp/handbook/H/en','https://www.fao.org/fishery/en/area/','FAO Major Fishing Areas');
INSERT INTO gazetteer VALUES('LONGHURST','longhurst','Longhurst Biogeographical Provinces','http://www.marineregions.org/sources.php#longhurst','','Longhurst Biogeographical Provinces, a partition of the world oceans into provinces as defined by Longhurst, A.R. (2006). Ecological Geography of the Sea. 2nd Edition.');
INSERT INTO gazetteer VALUES('TEOW','teow','Terrestrial Ecoregions of the World','https://www.worldwildlife.org/publications/terrestrial-ecoregions-of-the-world','','Terrestrial Ecoregions of the World is a biogeographic regionalization of the Earth''s terrestrial biodiversity. See Olson et al. 2001. Terrestrial ecoregions of the world: a new map of life on Earth. Bioscience 51(11):933-938.');
INSERT INTO gazetteer VALUES('IHO','iho','International Hydrographic Organization See Areas','','','Sea areas published by the International Hydrographic Organization as boundaries of the major oceans and seas of the world. See Limits of Oceans & Seas, Special Publication No. 23 published by the International Hydrographic Organization in 1953.');
INSERT INTO gazetteer VALUES('MRGID','mrgid','Marine Regions Geographic Identifier','https://www.marineregions.org/gazetteer.php','http://marineregions.org/mrgid/','Standard, relational list of geographic names developed by VLIZ covering mainly marine names such as seas, sandbanks, ridges, bays or even standard sampling stations used in marine research.The geographic cover is global; however the gazetteer is focused on the Belgian Continental Shelf, the Scheldt Estuary and the Southern Bight of the North Sea.');
INSERT INTO gazetteer VALUES('TEXT','text','Free Text','','','Free text not following any standard');
CREATE TABLE rank(
  id TEXT PRIMARY KEY,
  name TEXT DEFAULT '',
  plural TEXT DEFAULT '',
  marker TEXT DEFAULT '',
  major_rank_id TEXT REFERENCES rank,
  ambiguous_marker INTEGER DEFAULT 0, -- bool
  family_group INTEGER DEFAULT 0, -- bool
  genus_group INTEGER DEFAULT 0, -- bool
  infraspecific INTEGER DEFAULT 0, -- bool
  legacy INTEGER DEFAULT 0, -- bool
  linnean INTEGER DEFAULT 0, -- bool
  suprageneric INTEGER DEFAULT 0, -- bool
  supraspecific INTEGER DEFAULT 0, -- bool
  uncomparable INTEGER DEFAULT 0 -- bool
) STRICT;
INSERT INTO rank VALUES('','','','','',0,0,0,0,0,0,0,0,0);
INSERT INTO rank VALUES('SUPERDOMAIN','superdomain','superdomains','superdom.','DOMAIN',0,0,0,0,0,0,1,1,0);
INSERT INTO rank VALUES('DOMAIN','domain','domains','dom.','DOMAIN',0,0,0,0,0,0,1,1,0);
INSERT INTO rank VALUES('SUBDOMAIN','subdomain','subdomains','subdom.','DOMAIN',0,0,0,0,0,0,1,1,0);
INSERT INTO rank VALUES('INFRADOMAIN','infradomain','infradomains','infradom.','DOMAIN',0,0,0,0,0,0,1,1,0);
INSERT INTO rank VALUES('EMPIRE','empire','empires','imp.','EMPIRE',0,0,0,0,0,0,1,1,0);
INSERT INTO rank VALUES('REALM','realm','realms','realm','REALM',0,0,0,0,0,0,1,1,0);
INSERT INTO rank VALUES('SUBREALM','subrealm','subrealms','subrealm','REALM',0,0,0,0,0,0,1,1,0);
INSERT INTO rank VALUES('SUPERKINGDOM','superkingdom','superkingdoms','superreg.','KINGDOM',0,0,0,0,0,0,1,1,0);
INSERT INTO rank VALUES('KINGDOM','kingdom','kingdoms','regn.','KINGDOM',0,0,0,0,0,1,1,1,0);
INSERT INTO rank VALUES('SUBKINGDOM','subkingdom','subkingdoms','subreg.','KINGDOM',0,0,0,0,0,0,1,1,0);
INSERT INTO rank VALUES('INFRAKINGDOM','infrakingdom','infrakingdoms','infrareg.','KINGDOM',0,0,0,0,0,0,1,1,0);
INSERT INTO rank VALUES('SUPERPHYLUM','superphylum','superphyla','superphyl.','PHYLUM',0,0,0,0,0,0,1,1,0);
INSERT INTO rank VALUES('PHYLUM','phylum','phyla','phyl.','PHYLUM',0,0,0,0,0,1,1,1,0);
INSERT INTO rank VALUES('SUBPHYLUM','subphylum','subphyla','subphyl.','PHYLUM',0,0,0,0,0,0,1,1,0);
INSERT INTO rank VALUES('INFRAPHYLUM','infraphylum','infraphyla','infraphyl.','PHYLUM',0,0,0,0,0,0,1,1,0);
INSERT INTO rank VALUES('PARVPHYLUM','parvphylum','parvphyla','parvphyl.','PHYLUM',0,0,0,0,0,0,1,1,0);
INSERT INTO rank VALUES('MICROPHYLUM','microphylum','microphyla','microphyl.','PHYLUM',0,0,0,0,0,0,1,1,0);
INSERT INTO rank VALUES('NANOPHYLUM','nanophylum','nanophyla','nanophyl.','PHYLUM',0,0,0,0,0,0,1,1,0);
INSERT INTO rank VALUES('CLAUDIUS','claudius','claudius','claud.','CLAUDIUS',0,0,0,0,0,0,1,1,0);
INSERT INTO rank VALUES('GIGACLASS','gigaclass','gigaclasses','gigacl.','CLASS',0,0,0,0,0,0,1,1,0);
INSERT INTO rank VALUES('MEGACLASS','megaclass','megaclasses','megacl.','CLASS',0,0,0,0,0,0,1,1,0);
INSERT INTO rank VALUES('SUPERCLASS','superclass','superclasses','supercl.','CLASS',0,0,0,0,0,0,1,1,0);
INSERT INTO rank VALUES('CLASS','class','classes','cl.','CLASS',0,0,0,0,0,1,1,1,0);
INSERT INTO rank VALUES('SUBCLASS','subclass','subclasses','subcl.','CLASS',0,0,0,0,0,0,1,1,0);
INSERT INTO rank VALUES('INFRACLASS','infraclass','infraclasses','infracl.','CLASS',0,0,0,0,0,0,1,1,0);
INSERT INTO rank VALUES('SUBTERCLASS','subterclass','subterclasses','subtercl.','CLASS',0,0,0,0,0,0,1,1,0);
INSERT INTO rank VALUES('PARVCLASS','parvclass','parvclasses','parvcl.','CLASS',0,0,0,0,0,0,1,1,0);
INSERT INTO rank VALUES('SUPERDIVISION','superdivision','superdivisions','superdiv.','DIVISION',0,0,0,0,0,0,1,1,0);
INSERT INTO rank VALUES('DIVISION','division','divisions','div.','DIVISION',0,0,0,0,0,0,1,1,0);
INSERT INTO rank VALUES('SUBDIVISION','subdivision','subdivisions','subdiv.','DIVISION',0,0,0,0,0,0,1,1,0);
INSERT INTO rank VALUES('INFRADIVISION','infradivision','infradivisions','infradiv.','DIVISION',0,0,0,0,0,0,1,1,0);
INSERT INTO rank VALUES('SUPERLEGION','superlegion','superlegions','superleg.','LEGION',0,0,0,0,0,0,1,1,0);
INSERT INTO rank VALUES('LEGION','legion','legions','leg.','LEGION',0,0,0,0,0,0,1,1,0);
INSERT INTO rank VALUES('SUBLEGION','sublegion','sublegions','subleg.','LEGION',0,0,0,0,0,0,1,1,0);
INSERT INTO rank VALUES('INFRALEGION','infralegion','infralegions','infraleg.','LEGION',0,0,0,0,0,0,1,1,0);
INSERT INTO rank VALUES('MEGACOHORT','megacohort','megacohorts','megacohort','COHORT',0,0,0,0,0,0,1,1,0);
INSERT INTO rank VALUES('SUPERCOHORT','supercohort','supercohorts','supercohort','COHORT',0,0,0,0,0,0,1,1,0);
INSERT INTO rank VALUES('COHORT','cohort','cohorts','cohort','COHORT',0,0,0,0,0,0,1,1,0);
INSERT INTO rank VALUES('SUBCOHORT','subcohort','subcohorts','subcohort','COHORT',0,0,0,0,0,0,1,1,0);
INSERT INTO rank VALUES('INFRACOHORT','infracohort','infracohorts','infracohort','COHORT',0,0,0,0,0,0,1,1,0);
INSERT INTO rank VALUES('GIGAORDER','gigaorder','gigaorders','gigaord.','ORDER',0,0,0,0,0,0,1,1,0);
INSERT INTO rank VALUES('MAGNORDER','magnorder','magnorders','magnord.','ORDER',0,0,0,0,0,0,1,1,0);
INSERT INTO rank VALUES('GRANDORDER','grandorder','grandorders','grandord.','ORDER',0,0,0,0,0,0,1,1,0);
INSERT INTO rank VALUES('MIRORDER','mirorder','mirorders','mirord.','ORDER',0,0,0,0,0,0,1,1,0);
INSERT INTO rank VALUES('SUPERORDER','superorder','superorders','superord.','ORDER',0,0,0,0,0,0,1,1,0);
INSERT INTO rank VALUES('ORDER','order','orders','ord.','ORDER',0,0,0,0,0,1,1,1,0);
INSERT INTO rank VALUES('NANORDER','nanorder','nanorders','nanord.','ORDER',0,0,0,0,0,0,1,1,0);
INSERT INTO rank VALUES('HYPOORDER','hypoorder','hypoorders','hypoord.','ORDER',0,0,0,0,0,0,1,1,0);
INSERT INTO rank VALUES('MINORDER','minorder','minorders','minord.','ORDER',0,0,0,0,0,0,1,1,0);
INSERT INTO rank VALUES('SUBORDER','suborder','suborders','subord.','ORDER',0,0,0,0,0,0,1,1,0);
INSERT INTO rank VALUES('INFRAORDER','infraorder','infraorders','infraord.','ORDER',0,0,0,0,0,0,1,1,0);
INSERT INTO rank VALUES('PARVORDER','parvorder','parvorders','parvord.','ORDER',0,0,0,0,0,0,1,1,0);
INSERT INTO rank VALUES('SUPERSECTION_ZOOLOGY','supersection zoology','supersection_zoologys','supersect.','SECTION_ZOOLOGY',1,0,0,0,0,0,1,1,0);
INSERT INTO rank VALUES('SECTION_ZOOLOGY','section zoology','section_zoologys','sect.','SECTION_ZOOLOGY',1,0,0,0,0,0,1,1,0);
INSERT INTO rank VALUES('SUBSECTION_ZOOLOGY','subsection zoology','subsection_zoologys','subsect.','SECTION_ZOOLOGY',1,0,0,0,0,0,1,1,0);
INSERT INTO rank VALUES('FALANX','falanx','falanges','falanx','FALANX',0,0,0,0,1,0,1,1,0);
INSERT INTO rank VALUES('GIGAFAMILY','gigafamily','gigafamilies','gigafam.','FAMILY',0,0,0,0,0,0,1,1,0);
INSERT INTO rank VALUES('MEGAFAMILY','megafamily','megafamilies','megafam.','FAMILY',0,0,0,0,0,0,1,1,0);
INSERT INTO rank VALUES('GRANDFAMILY','grandfamily','grandfamilies','grandfam.','FAMILY',0,0,0,0,0,0,1,1,0);
INSERT INTO rank VALUES('SUPERFAMILY','superfamily','superfamilies','superfam.','FAMILY',0,0,0,0,0,0,1,1,0);
INSERT INTO rank VALUES('EPIFAMILY','epifamily','epifamilies','epifam.','FAMILY',0,0,0,0,0,0,1,1,0);
INSERT INTO rank VALUES('FAMILY','family','families','fam.','FAMILY',0,0,0,0,0,1,1,1,0);
INSERT INTO rank VALUES('SUBFAMILY','subfamily','subfamilies','subfam.','FAMILY',0,0,0,0,0,0,1,1,0);
INSERT INTO rank VALUES('INFRAFAMILY','infrafamily','infrafamilies','infrafam.','FAMILY',0,0,0,0,0,0,1,1,0);
INSERT INTO rank VALUES('SUPERTRIBE','supertribe','supertribes','supertrib.','TRIBE',0,0,0,0,0,0,1,1,0);
INSERT INTO rank VALUES('TRIBE','tribe','tribes','trib.','TRIBE',0,0,0,0,0,0,1,1,0);
INSERT INTO rank VALUES('SUBTRIBE','subtribe','subtribes','subtrib.','TRIBE',0,0,0,0,0,0,1,1,0);
INSERT INTO rank VALUES('INFRATRIBE','infratribe','infratribes','infratrib.','TRIBE',0,0,0,0,0,0,1,1,0);
INSERT INTO rank VALUES('SUPRAGENERIC_NAME','suprageneric name','suprageneric_names','supragen.','SUPRAGENERIC_NAME',0,0,0,0,0,0,1,1,1);
INSERT INTO rank VALUES('SUPERGENUS','supergenus','supergenera','supergen.','GENUS',0,0,1,0,0,0,1,1,0);
INSERT INTO rank VALUES('GENUS','genus','genera','gen.','GENUS',0,0,1,0,0,1,0,1,0);
INSERT INTO rank VALUES('SUBGENUS','subgenus','subgenera','subgen.','GENUS',0,0,1,0,0,0,0,1,0);
INSERT INTO rank VALUES('INFRAGENUS','infragenus','infragenera','infrag.','GENUS',0,0,1,0,0,0,0,1,0);
INSERT INTO rank VALUES('SUPERSECTION_BOTANY','supersection botany','supersection_botanys','supersect.','SECTION_BOTANY',1,0,1,0,0,0,0,1,0);
INSERT INTO rank VALUES('SECTION_BOTANY','section botany','section_botanys','sect.','SECTION_BOTANY',1,0,1,0,0,0,0,1,0);
INSERT INTO rank VALUES('SUBSECTION_BOTANY','subsection botany','subsection_botanys','subsect.','SECTION_BOTANY',1,0,1,0,0,0,0,1,0);
INSERT INTO rank VALUES('SUPERSERIES','superseries','superseries','superser.','SERIES',0,0,1,0,0,0,0,1,0);
INSERT INTO rank VALUES('SERIES','series','series','ser.','SERIES',0,0,1,0,0,0,0,1,0);
INSERT INTO rank VALUES('SUBSERIES','subseries','subseries','subser.','SERIES',0,0,1,0,0,0,0,1,0);
INSERT INTO rank VALUES('INFRAGENERIC_NAME','infrageneric name','infrageneric_names','infragen.','GENUS',0,0,1,0,0,0,0,1,1);
INSERT INTO rank VALUES('SPECIES_AGGREGATE','species aggregate','species_aggregates','agg.','SPECIES',0,0,0,0,0,0,0,0,0);
INSERT INTO rank VALUES('SPECIES','species','species','sp.','SPECIES',0,0,0,0,0,1,0,0,0);
INSERT INTO rank VALUES('INFRASPECIFIC_NAME','infraspecific name','infraspecific_names','infrasp.','INFRASPECIFIC_NAME',0,0,0,1,0,0,0,0,1);
INSERT INTO rank VALUES('GREX','grex','grexs','gx','INFRASPECIFIC_NAME',0,0,0,1,0,0,0,0,0);
INSERT INTO rank VALUES('KLEPTON','klepton','kleptons','klepton','INFRASPECIFIC_NAME',0,0,0,1,1,0,0,0,0);
INSERT INTO rank VALUES('SUBSPECIES','subspecies','subspecies','subsp.','INFRASPECIFIC_NAME',0,0,0,1,0,0,0,0,0);
INSERT INTO rank VALUES('CULTIVAR_GROUP','cultivar group','','','INFRASPECIFIC_NAME',0,0,0,1,0,0,0,0,0);
INSERT INTO rank VALUES('CONVARIETY','convariety','convarieties','convar.','INFRASPECIFIC_NAME',0,0,0,1,1,0,0,0,0);
INSERT INTO rank VALUES('INFRASUBSPECIFIC_NAME','infrasubspecific name','infrasubspecific_names','infrasubsp.','INFRASPECIFIC_NAME',0,0,0,1,0,0,0,0,1);
INSERT INTO rank VALUES('PROLES','proles','proles','prol.','INFRASPECIFIC_NAME',0,0,0,1,1,0,0,0,0);
INSERT INTO rank VALUES('NATIO','natio','natios','natio','INFRASPECIFIC_NAME',0,0,0,1,1,0,0,0,0);
INSERT INTO rank VALUES('ABERRATION','aberration','aberrations','ab.','INFRASPECIFIC_NAME',0,0,0,1,1,0,0,0,0);
INSERT INTO rank VALUES('MORPH','morph','morphs','morph','INFRASPECIFIC_NAME',0,0,0,1,1,0,0,0,0);
INSERT INTO rank VALUES('SUPERVARIETY','supervariety','supervarieties','supervar.','INFRASPECIFIC_NAME',0,0,0,1,0,0,0,0,0);
INSERT INTO rank VALUES('VARIETY','variety','varieties','var.','INFRASPECIFIC_NAME',0,0,0,1,0,0,0,0,0);
INSERT INTO rank VALUES('SUBVARIETY','subvariety','subvarieties','subvar.','INFRASPECIFIC_NAME',0,0,0,1,0,0,0,0,0);
INSERT INTO rank VALUES('SUPERFORM','superform','superforms','superf.','INFRASPECIFIC_NAME',0,0,0,1,0,0,0,0,0);
INSERT INTO rank VALUES('FORM','form','forms','f.','INFRASPECIFIC_NAME',0,0,0,1,0,0,0,0,0);
INSERT INTO rank VALUES('SUBFORM','subform','subforms','subf.','INFRASPECIFIC_NAME',0,0,0,1,0,0,0,0,0);
INSERT INTO rank VALUES('PATHOVAR','pathovar','pathovars','pv.','INFRASPECIFIC_NAME',0,0,0,1,0,0,0,0,0);
INSERT INTO rank VALUES('BIOVAR','biovar','biovars','biovar','INFRASPECIFIC_NAME',0,0,0,1,0,0,0,0,0);
INSERT INTO rank VALUES('CHEMOVAR','chemovar','chemovars','chemovar','INFRASPECIFIC_NAME',0,0,0,1,0,0,0,0,0);
INSERT INTO rank VALUES('MORPHOVAR','morphovar','morphovars','morphovar','INFRASPECIFIC_NAME',0,0,0,1,0,0,0,0,0);
INSERT INTO rank VALUES('PHAGOVAR','phagovar','phagovars','phagovar','INFRASPECIFIC_NAME',0,0,0,1,0,0,0,0,0);
INSERT INTO rank VALUES('SEROVAR','serovar','serovars','serovar','INFRASPECIFIC_NAME',0,0,0,1,0,0,0,0,0);
INSERT INTO rank VALUES('CHEMOFORM','chemoform','chemoforms','chemoform','INFRASPECIFIC_NAME',0,0,0,1,0,0,0,0,0);
INSERT INTO rank VALUES('FORMA_SPECIALIS','forma specialis','forma_specialiss','f.sp.','INFRASPECIFIC_NAME',0,0,0,1,0,0,0,0,0);
INSERT INTO rank VALUES('LUSUS','lusus','lusi','lusus','INFRASPECIFIC_NAME',0,0,0,1,1,0,0,0,0);
INSERT INTO rank VALUES('CULTIVAR','cultivar','cultivars','cv.','INFRASPECIFIC_NAME',0,0,0,1,0,0,0,0,0);
INSERT INTO rank VALUES('MUTATIO','mutatio','mutatios','mut.','INFRASPECIFIC_NAME',0,0,0,1,0,0,0,0,0);
INSERT INTO rank VALUES('STRAIN','strain','strains','strain','INFRASPECIFIC_NAME',0,0,0,1,0,0,0,0,0);
INSERT INTO rank VALUES('OTHER','other','','','OTHER',0,0,0,0,0,0,0,0,1);
INSERT INTO rank VALUES('UNRANKED','unranked','','','UNRANKED',0,0,0,0,0,0,0,0,1);
CREATE TABLE geo_time (
  id TEXT PRIMARY KEY,
  parent_id TEXT REFERENCES geo_time,
  name TEXT DEFAULT '',
  type TEXT DEFAULT '',
  start REAL DEFAULT 0,
  end REAL) STRICT;
INSERT INTO geo_time VALUES('','','','',0.0,0.0);
INSERT INTO geo_time VALUES('HADEAN','PRECAMBRIAN','Hadean','eon',4567.0,4000.0);
INSERT INTO geo_time VALUES('PRECAMBRIAN','','Precambrian','supereon',4567.0,541.0);
INSERT INTO geo_time VALUES('ARCHEAN','PRECAMBRIAN','Archean','eon',4000.0,2500.0);
INSERT INTO geo_time VALUES('EOARCHEAN','ARCHEAN','Eoarchean','era',4000.0,3600.0);
INSERT INTO geo_time VALUES('PALEOARCHEAN','ARCHEAN','Paleoarchean','era',3600.0,3200.0);
INSERT INTO geo_time VALUES('MESOARCHEAN','ARCHEAN','Mesoarchean','era',3200.0,2800.0);
INSERT INTO geo_time VALUES('NEOARCHEAN','ARCHEAN','Neoarchean','era',2800.0,2500.0);
INSERT INTO geo_time VALUES('PROTEROZOIC','PRECAMBRIAN','Proterozoic','eon',2500.0,541.0);
INSERT INTO geo_time VALUES('PALEOPROTEROZOIC','PROTEROZOIC','Paleoproterozoic','era',2500.0,1600.0);
INSERT INTO geo_time VALUES('SIDERIAN','PALEOPROTEROZOIC','Siderian','period',2500.0,2300.0);
INSERT INTO geo_time VALUES('RHYACIAN','PALEOPROTEROZOIC','Rhyacian','period',2300.0,2050.0);
INSERT INTO geo_time VALUES('OROSIRIAN','PALEOPROTEROZOIC','Orosirian','period',2050.0,1800.0);
INSERT INTO geo_time VALUES('STATHERIAN','PALEOPROTEROZOIC','Statherian','period',1800.0,1600.0);
INSERT INTO geo_time VALUES('MESOPROTEROZOIC','PROTEROZOIC','Mesoproterozoic','era',1600.0,1000.0);
INSERT INTO geo_time VALUES('CALYMMIAN','MESOPROTEROZOIC','Calymmian','period',1600.0,1400.0);
INSERT INTO geo_time VALUES('ECTASIAN','MESOPROTEROZOIC','Ectasian','period',1400.0,1200.0);
INSERT INTO geo_time VALUES('STENIAN','MESOPROTEROZOIC','Stenian','period',1200.0,1000.0);
INSERT INTO geo_time VALUES('TONIAN','NEOPROTEROZOIC','Tonian','period',1000.0,720.0);
INSERT INTO geo_time VALUES('NEOPROTEROZOIC','PROTEROZOIC','Neoproterozoic','era',1000.0,541.0);
INSERT INTO geo_time VALUES('CRYOGENIAN','NEOPROTEROZOIC','Cryogenian','period',720.0,635.0);
INSERT INTO geo_time VALUES('EDIACARAN','NEOPROTEROZOIC','Ediacaran','period',635.0,541.0);
INSERT INTO geo_time VALUES('CAMBRIAN','PALEOZOIC','Cambrian','period',541.0,485.3999999999999773);
INSERT INTO geo_time VALUES('FORTUNIAN','TERRENEUVIAN','Fortunian','age',541.0,529.0);
INSERT INTO geo_time VALUES('PALEOZOIC','PHANEROZOIC','Paleozoic','era',541.0,251.9019999999999869);
INSERT INTO geo_time VALUES('PHANEROZOIC','','Phanerozoic','eon',541.0,0.0);
INSERT INTO geo_time VALUES('TERRENEUVIAN','CAMBRIAN','Terreneuvian','epoch',541.0,521.0);
INSERT INTO geo_time VALUES('CAMBRIANSTAGE2','TERRENEUVIAN','CambrianStage2','age',529.0,521.0);
INSERT INTO geo_time VALUES('CAMBRIANSERIES2','CAMBRIAN','CambrianSeries2','epoch',521.0,509.0);
INSERT INTO geo_time VALUES('CAMBRIANSTAGE3','CAMBRIANSERIES2','CambrianStage3','age',521.0,514.0);
INSERT INTO geo_time VALUES('CAMBRIANSTAGE4','CAMBRIANSERIES2','CambrianStage4','age',514.0,509.0);
INSERT INTO geo_time VALUES('WULIUAN','MIAOLINGIAN','Wuliuan','age',509.0,504.5);
INSERT INTO geo_time VALUES('MIAOLINGIAN','CAMBRIAN','Miaolingian','epoch',509.0,497.0);
INSERT INTO geo_time VALUES('DRUMIAN','MIAOLINGIAN','Drumian','age',504.5,500.5);
INSERT INTO geo_time VALUES('GUZHANGIAN','MIAOLINGIAN','Guzhangian','age',500.5,497.0);
INSERT INTO geo_time VALUES('FURONGIAN','CAMBRIAN','Furongian','epoch',497.0,485.3999999999999773);
INSERT INTO geo_time VALUES('PAIBIAN','FURONGIAN','Paibian','age',497.0,494.0);
INSERT INTO geo_time VALUES('JIANGSHANIAN','FURONGIAN','Jiangshanian','age',494.0,489.5);
INSERT INTO geo_time VALUES('CAMBRIANSTAGE10','FURONGIAN','CambrianStage10','age',489.5,485.3999999999999773);
INSERT INTO geo_time VALUES('TREMADOCIAN','LOWER_ORDOVICIAN','Tremadocian','age',485.3999999999999773,477.6999999999999887);
INSERT INTO geo_time VALUES('LOWER_ORDOVICIAN','ORDOVICIAN','LowerOrdovician','epoch',485.3999999999999773,470.0);
INSERT INTO geo_time VALUES('ORDOVICIAN','PALEOZOIC','Ordovician','period',485.3999999999999773,443.8000000000000113);
INSERT INTO geo_time VALUES('FLOIAN','LOWER_ORDOVICIAN','Floian','age',477.6999999999999887,470.0);
INSERT INTO geo_time VALUES('DAPINGIAN','MIDDLE_ORDOVICIAN','Dapingian','age',470.0,467.3000000000000113);
INSERT INTO geo_time VALUES('MIDDLE_ORDOVICIAN','ORDOVICIAN','MiddleOrdovician','epoch',470.0,458.3999999999999773);
INSERT INTO geo_time VALUES('DARRIWILIAN','MIDDLE_ORDOVICIAN','Darriwilian','age',467.3000000000000113,458.3999999999999773);
INSERT INTO geo_time VALUES('SANDBIAN','UPPER_ORDOVICIAN','Sandbian','age',458.3999999999999773,453.0);
INSERT INTO geo_time VALUES('UPPER_ORDOVICIAN','ORDOVICIAN','UpperOrdovician','epoch',458.3999999999999773,443.8000000000000113);
INSERT INTO geo_time VALUES('KATIAN','UPPER_ORDOVICIAN','Katian','age',453.0,445.1999999999999887);
INSERT INTO geo_time VALUES('HIRNANTIAN','UPPER_ORDOVICIAN','Hirnantian','age',445.1999999999999887,443.8000000000000113);
INSERT INTO geo_time VALUES('LLANDOVERY','SILURIAN','Llandovery','epoch',443.8000000000000113,433.3999999999999773);
INSERT INTO geo_time VALUES('RHUDDANIAN','LLANDOVERY','Rhuddanian','age',443.8000000000000113,440.8000000000000113);
INSERT INTO geo_time VALUES('SILURIAN','PALEOZOIC','Silurian','period',443.8000000000000113,419.1999999999999887);
INSERT INTO geo_time VALUES('AERONIAN','LLANDOVERY','Aeronian','age',440.8000000000000113,438.5);
INSERT INTO geo_time VALUES('TELYCHIAN','LLANDOVERY','Telychian','age',438.5,433.3999999999999773);
INSERT INTO geo_time VALUES('SHEINWOODIAN','WENLOCK','Sheinwoodian','age',433.3999999999999773,430.5);
INSERT INTO geo_time VALUES('WENLOCK','SILURIAN','Wenlock','epoch',433.3999999999999773,427.3999999999999773);
INSERT INTO geo_time VALUES('HOMERIAN','WENLOCK','Homerian','age',430.5,427.3999999999999773);
INSERT INTO geo_time VALUES('LUDLOW','SILURIAN','Ludlow','epoch',427.3999999999999773,423.0);
INSERT INTO geo_time VALUES('GORSTIAN','LUDLOW','Gorstian','age',427.3999999999999773,425.6000000000000227);
INSERT INTO geo_time VALUES('LUDFORDIAN','LUDLOW','Ludfordian','age',425.6000000000000227,423.0);
INSERT INTO geo_time VALUES('PRIDOLI','SILURIAN','Pridoli','age',423.0,419.1999999999999887);
INSERT INTO geo_time VALUES('DEVONIAN','PALEOZOIC','Devonian','period',419.1999999999999887,358.8999999999999773);
INSERT INTO geo_time VALUES('LOWER_DEVONIAN','DEVONIAN','LowerDevonian','epoch',419.1999999999999887,393.3000000000000113);
INSERT INTO geo_time VALUES('LOCHKOVIAN','LOWER_DEVONIAN','Lochkovian','age',419.1999999999999887,410.8000000000000113);
INSERT INTO geo_time VALUES('PRAGIAN','LOWER_DEVONIAN','Pragian','age',410.8000000000000113,407.6000000000000227);
INSERT INTO geo_time VALUES('EMSIAN','LOWER_DEVONIAN','Emsian','age',407.6000000000000227,393.3000000000000113);
INSERT INTO geo_time VALUES('EIFELIAN','MIDDLE_DEVONIAN','Eifelian','age',393.3000000000000113,387.6999999999999887);
INSERT INTO geo_time VALUES('MIDDLE_DEVONIAN','DEVONIAN','MiddleDevonian','epoch',393.3000000000000113,382.6999999999999887);
INSERT INTO geo_time VALUES('GIVETIAN','MIDDLE_DEVONIAN','Givetian','age',387.6999999999999887,382.6999999999999887);
INSERT INTO geo_time VALUES('UPPER_DEVONIAN','DEVONIAN','UpperDevonian','epoch',382.6999999999999887,358.8999999999999773);
INSERT INTO geo_time VALUES('FRASNIAN','UPPER_DEVONIAN','Frasnian','age',382.6999999999999887,372.1999999999999887);
INSERT INTO geo_time VALUES('FAMENNIAN','UPPER_DEVONIAN','Famennian','age',372.1999999999999887,358.8999999999999773);
INSERT INTO geo_time VALUES('LOWER_MISSISSIPPIAN','MISSISSIPPIAN','LowerMississippian','epoch',358.8999999999999773,346.6999999999999887);
INSERT INTO geo_time VALUES('TOURNAISIAN','LOWER_MISSISSIPPIAN','Tournaisian','age',358.8999999999999773,346.6999999999999887);
INSERT INTO geo_time VALUES('MISSISSIPPIAN','CARBONIFEROUS','Mississippian','subperiod',358.8999999999999773,323.1999999999999887);
INSERT INTO geo_time VALUES('CARBONIFEROUS','PALEOZOIC','Carboniferous','period',358.8999999999999773,298.8999999999999773);
INSERT INTO geo_time VALUES('MIDDLE_MISSISSIPPIAN','MISSISSIPPIAN','MiddleMississippian','epoch',346.6999999999999887,330.8999999999999773);
INSERT INTO geo_time VALUES('VISEAN','MIDDLE_MISSISSIPPIAN','Visean','age',346.6999999999999887,330.8999999999999773);
INSERT INTO geo_time VALUES('SERPUKHOVIAN','UPPER_MISSISSIPPIAN','Serpukhovian','age',330.8999999999999773,323.1999999999999887);
INSERT INTO geo_time VALUES('UPPER_MISSISSIPPIAN','MISSISSIPPIAN','UpperMississippian','epoch',330.8999999999999773,298.8999999999999773);
INSERT INTO geo_time VALUES('BASHKIRIAN','LOWER_PENNSYLVANIAN','Bashkirian','age',323.1999999999999887,315.1999999999999887);
INSERT INTO geo_time VALUES('PENNSYLVANIAN','CARBONIFEROUS','Pennsylvanian','subperiod',323.1999999999999887,298.8999999999999773);
INSERT INTO geo_time VALUES('LOWER_PENNSYLVANIAN','PENNSYLVANIAN','LowerPennsylvanian','epoch',323.1999999999999887,315.1999999999999887);
INSERT INTO geo_time VALUES('MIDDLE_PENNSYLVANIAN','PENNSYLVANIAN','MiddlePennsylvanian','epoch',315.1999999999999887,307.0);
INSERT INTO geo_time VALUES('MOSCOVIAN','MIDDLE_PENNSYLVANIAN','Moscovian','age',315.1999999999999887,307.0);
INSERT INTO geo_time VALUES('KASIMOVIAN','UPPER_PENNSYLVANIAN','Kasimovian','age',307.0,303.6999999999999887);
INSERT INTO geo_time VALUES('UPPER_PENNSYLVANIAN','PENNSYLVANIAN','UpperPennsylvanian','epoch',307.0,298.8999999999999773);
INSERT INTO geo_time VALUES('GZHELIAN','UPPER_PENNSYLVANIAN','Gzhelian','age',303.6999999999999887,298.8999999999999773);
INSERT INTO geo_time VALUES('CISURALIAN','PERMIAN','Cisuralian','epoch',298.8999999999999773,272.9499999999999887);
INSERT INTO geo_time VALUES('ASSELIAN','CISURALIAN','Asselian','age',298.8999999999999773,295.0);
INSERT INTO geo_time VALUES('PERMIAN','PALEOZOIC','Permian','period',298.8999999999999773,251.9019999999999869);
INSERT INTO geo_time VALUES('SAKMARIAN','CISURALIAN','Sakmarian','age',295.0,290.1000000000000227);
INSERT INTO geo_time VALUES('ARTINSKIAN','CISURALIAN','Artinskian','age',290.1000000000000227,283.5);
INSERT INTO geo_time VALUES('KUNGURIAN','CISURALIAN','Kungurian','age',283.5,272.9499999999999887);
INSERT INTO geo_time VALUES('ROADIAN','GUADALUPIAN','Roadian','age',272.9499999999999887,268.8000000000000113);
INSERT INTO geo_time VALUES('GUADALUPIAN','PERMIAN','Guadalupian','epoch',272.9499999999999887,259.1000000000000227);
INSERT INTO geo_time VALUES('WORDIAN','GUADALUPIAN','Wordian','age',268.8000000000000113,265.1000000000000227);
INSERT INTO geo_time VALUES('CAPITANIAN','GUADALUPIAN','Capitanian','age',265.1000000000000227,259.1000000000000227);
INSERT INTO geo_time VALUES('LOPINGIAN','PERMIAN','Lopingian','epoch',259.1000000000000227,251.9019999999999869);
INSERT INTO geo_time VALUES('WUCHIAPINGIAN','LOPINGIAN','Wuchiapingian','age',259.1000000000000227,254.1399999999999864);
INSERT INTO geo_time VALUES('CHANGHSINGIAN','LOPINGIAN','Changhsingian','age',254.1399999999999864,251.9019999999999869);
INSERT INTO geo_time VALUES('INDUAN','LOWER_TRIASSIC','Induan','age',251.9019999999999869,251.1999999999999887);
INSERT INTO geo_time VALUES('LOWER_TRIASSIC','TRIASSIC','LowerTriassic','epoch',251.9019999999999869,247.1999999999999887);
INSERT INTO geo_time VALUES('MESOZOIC','PHANEROZOIC','Mesozoic','era',251.9019999999999869,66.0);
INSERT INTO geo_time VALUES('TRIASSIC','MESOZOIC','Triassic','period',251.9019999999999869,201.3000000000000113);
INSERT INTO geo_time VALUES('OLENEKIAN','LOWER_TRIASSIC','Olenekian','age',251.1999999999999887,247.1999999999999887);
INSERT INTO geo_time VALUES('ANISIAN','MIDDLE_TRIASSIC','Anisian','age',247.1999999999999887,242.0);
INSERT INTO geo_time VALUES('MIDDLE_TRIASSIC','TRIASSIC','MiddleTriassic','epoch',247.1999999999999887,237.0);
INSERT INTO geo_time VALUES('LADINIAN','MIDDLE_TRIASSIC','Ladinian','age',242.0,237.0);
INSERT INTO geo_time VALUES('CARNIAN','UPPER_TRIASSIC','Carnian','age',237.0,227.0);
INSERT INTO geo_time VALUES('UPPER_TRIASSIC','TRIASSIC','UpperTriassic','epoch',237.0,201.3000000000000113);
INSERT INTO geo_time VALUES('NORIAN','UPPER_TRIASSIC','Norian','age',227.0,208.5);
INSERT INTO geo_time VALUES('RHAETIAN','UPPER_TRIASSIC','Rhaetian','age',208.5,201.3000000000000113);
INSERT INTO geo_time VALUES('JURASSIC','MESOZOIC','Jurassic','period',201.3000000000000113,145.0);
INSERT INTO geo_time VALUES('HETTANGIAN','LOWER_JURASSIC','Hettangian','age',201.3000000000000113,199.3000000000000113);
INSERT INTO geo_time VALUES('LOWER_JURASSIC','JURASSIC','LowerJurassic','epoch',201.3000000000000113,174.0999999999999944);
INSERT INTO geo_time VALUES('SINEMURIAN','LOWER_JURASSIC','Sinemurian','age',199.3000000000000113,190.8000000000000113);
INSERT INTO geo_time VALUES('PLIENSBACHIAN','LOWER_JURASSIC','Pliensbachian','age',190.8000000000000113,182.6999999999999887);
INSERT INTO geo_time VALUES('TOARCIAN','LOWER_JURASSIC','Toarcian','age',182.6999999999999887,174.0999999999999944);
INSERT INTO geo_time VALUES('MIDDLE_JURASSIC','JURASSIC','MiddleJurassic','epoch',174.0999999999999944,163.5);
INSERT INTO geo_time VALUES('AALENIAN','MIDDLE_JURASSIC','Aalenian','age',174.0999999999999944,170.3000000000000113);
INSERT INTO geo_time VALUES('BAJOCIAN','MIDDLE_JURASSIC','Bajocian','age',170.3000000000000113,168.3000000000000113);
INSERT INTO geo_time VALUES('BATHONIAN','MIDDLE_JURASSIC','Bathonian','age',168.3000000000000113,166.0999999999999944);
INSERT INTO geo_time VALUES('CALLOVIAN','MIDDLE_JURASSIC','Callovian','age',166.0999999999999944,163.5);
INSERT INTO geo_time VALUES('OXFORDIAN','UPPER_JURASSIC','Oxfordian','age',163.5,157.3000000000000113);
INSERT INTO geo_time VALUES('UPPER_JURASSIC','JURASSIC','UpperJurassic','epoch',163.5,145.0);
INSERT INTO geo_time VALUES('KIMMERIDGIAN','UPPER_JURASSIC','Kimmeridgian','age',157.3000000000000113,152.0999999999999944);
INSERT INTO geo_time VALUES('TITHONIAN','UPPER_JURASSIC','Tithonian','age',152.0999999999999944,145.0);
INSERT INTO geo_time VALUES('LOWER_CRETACEOUS','CRETACEOUS','LowerCretaceous','epoch',145.0,100.5);
INSERT INTO geo_time VALUES('CRETACEOUS','MESOZOIC','Cretaceous','period',145.0,66.0);
INSERT INTO geo_time VALUES('BERRIASIAN','LOWER_CRETACEOUS','Berriasian','age',145.0,139.8000000000000113);
INSERT INTO geo_time VALUES('VALANGINIAN','LOWER_CRETACEOUS','Valanginian','age',139.8000000000000113,132.9000000000000056);
INSERT INTO geo_time VALUES('HAUTERIVIAN','LOWER_CRETACEOUS','Hauterivian','age',132.9000000000000056,129.4000000000000056);
INSERT INTO geo_time VALUES('BARREMIAN','LOWER_CRETACEOUS','Barremian','age',129.4000000000000056,125.0);
INSERT INTO geo_time VALUES('APTIAN','LOWER_CRETACEOUS','Aptian','age',125.0,113.0);
INSERT INTO geo_time VALUES('ALBIAN','LOWER_CRETACEOUS','Albian','age',113.0,100.5);
INSERT INTO geo_time VALUES('CENOMANIAN','UPPER_CRETACEOUS','Cenomanian','age',100.5,93.9000000000000056);
INSERT INTO geo_time VALUES('UPPER_CRETACEOUS','CRETACEOUS','UpperCretaceous','epoch',100.5,66.0);
INSERT INTO geo_time VALUES('TURONIAN','UPPER_CRETACEOUS','Turonian','age',93.9000000000000056,89.79999999999999716);
INSERT INTO geo_time VALUES('CONIACIAN','UPPER_CRETACEOUS','Coniacian','age',89.79999999999999716,86.29999999999999716);
INSERT INTO geo_time VALUES('SANTONIAN','UPPER_CRETACEOUS','Santonian','age',86.29999999999999716,83.59999999999999431);
INSERT INTO geo_time VALUES('CAMPANIAN','UPPER_CRETACEOUS','Campanian','age',83.59999999999999431,72.09999999999999431);
INSERT INTO geo_time VALUES('MAASTRICHTIAN','UPPER_CRETACEOUS','Maastrichtian','age',72.09999999999999431,66.0);
INSERT INTO geo_time VALUES('PALEOCENE','PALEOGENE','Paleocene','epoch',66.0,56.0);
INSERT INTO geo_time VALUES('PALEOGENE','CENOZOIC','Paleogene','period',66.0,23.03000000000000113);
INSERT INTO geo_time VALUES('CENOZOIC','PHANEROZOIC','Cenozoic','era',66.0,0.0);
INSERT INTO geo_time VALUES('DANIAN','PALEOCENE','Danian','age',66.0,61.60000000000000142);
INSERT INTO geo_time VALUES('SELANDIAN','PALEOCENE','Selandian','age',61.60000000000000142,59.20000000000000284);
INSERT INTO geo_time VALUES('THANETIAN','PALEOCENE','Thanetian','age',59.20000000000000284,56.0);
INSERT INTO geo_time VALUES('EOCENE','PALEOGENE','Eocene','epoch',56.0,33.89999999999999858);
INSERT INTO geo_time VALUES('YPRESIAN','EOCENE','Ypresian','age',56.0,47.79999999999999716);
INSERT INTO geo_time VALUES('LUTETIAN','EOCENE','Lutetian','age',47.79999999999999716,41.20000000000000285);
INSERT INTO geo_time VALUES('BARTONIAN','EOCENE','Bartonian','age',41.20000000000000285,37.79999999999999715);
INSERT INTO geo_time VALUES('PRIABONIAN','EOCENE','Priabonian','age',37.79999999999999715,33.89999999999999858);
INSERT INTO geo_time VALUES('RUPELIAN','OLIGOCENE','Rupelian','age',33.89999999999999858,28.10000000000000142);
INSERT INTO geo_time VALUES('OLIGOCENE','PALEOGENE','Oligocene','epoch',33.89999999999999858,23.03000000000000113);
INSERT INTO geo_time VALUES('CHATTIAN','OLIGOCENE','Chattian','age',27.82000000000000028,23.03000000000000113);
INSERT INTO geo_time VALUES('AQUITANIAN','MIOCENE','Aquitanian','age',23.03000000000000113,20.44000000000000127);
INSERT INTO geo_time VALUES('NEOGENE','CENOZOIC','Neogene','period',23.03000000000000113,2.580000000000000071);
INSERT INTO geo_time VALUES('MIOCENE','NEOGENE','Miocene','epoch',23.03000000000000113,5.333000000000000184);
INSERT INTO geo_time VALUES('BURDIGALIAN','MIOCENE','Burdigalian','age',20.44000000000000127,15.97000000000000063);
INSERT INTO geo_time VALUES('LANGHIAN','MIOCENE','Langhian','age',15.97000000000000063,13.82000000000000028);
INSERT INTO geo_time VALUES('SERRAVALLIAN','MIOCENE','Serravallian','age',13.82000000000000028,11.63000000000000078);
INSERT INTO geo_time VALUES('TORTONIAN','MIOCENE','Tortonian','age',11.63000000000000078,7.24600000000000044);
INSERT INTO geo_time VALUES('MESSINIAN','MIOCENE','Messinian','age',7.24600000000000044,5.333000000000000184);
INSERT INTO geo_time VALUES('ZANCLEAN','PLIOCENE','Zanclean','age',5.333000000000000184,3.600000000000000088);
INSERT INTO geo_time VALUES('PLIOCENE','NEOGENE','Pliocene','epoch',5.333000000000000184,2.580000000000000071);
INSERT INTO geo_time VALUES('PIACENZIAN','PLIOCENE','Piacenzian','age',3.600000000000000088,2.580000000000000071);
INSERT INTO geo_time VALUES('QUATERNARY','CENOZOIC','Quaternary','period',2.580000000000000071,0.0);
INSERT INTO geo_time VALUES('GELASIAN','PLEISTOCENE','Gelasian','age',2.580000000000000071,1.800000000000000044);
INSERT INTO geo_time VALUES('PLEISTOCENE','QUATERNARY','Pleistocene','epoch',2.580000000000000071,0.01170000000000000033);
INSERT INTO geo_time VALUES('CALABRIAN','PLEISTOCENE','Calabrian','age',1.800000000000000044,0.7810000000000000275);
INSERT INTO geo_time VALUES('MIDDLE_PLEISTOCENE','PLEISTOCENE','MiddlePleistocene','age',0.7810000000000000275,0.1260000000000000008);
INSERT INTO geo_time VALUES('UPPER_PLEISTOCENE','PLEISTOCENE','UpperPleistocene','age',0.1260000000000000008,0.01170000000000000033);
INSERT INTO geo_time VALUES('HOLOCENE','QUATERNARY','Holocene','epoch',0.01170000000000000033,0.0);
INSERT INTO geo_time VALUES('GREENLANDIAN','HOLOCENE','Greenlandian','age',0.01170000000000000033,0.008200000000000000692);
INSERT INTO geo_time VALUES('NORTHGRIPPIAN','HOLOCENE','Northgrippian','age',0.008200000000000000692,0.00419999999999999974);
INSERT INTO geo_time VALUES('MEGHALAYAN','HOLOCENE','Meghalayan','age',0.00419999999999999974,0.0);
INSERT INTO sqlite_sequence VALUES('metadata',1);
CREATE INDEX idx_synonym_id ON synonym (id);
CREATE INDEX idx_synonym_taxon_id ON synonym (taxon_id);
CREATE INDEX idx_vernacular_taxon_id ON vernacular (taxon_id);
CREATE INDEX idx_type_material_id ON type_material (id);
COMMIT;
