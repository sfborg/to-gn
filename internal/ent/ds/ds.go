package ds

import (
	"net/url"
	"slices"
	"strings"
)

// DataSourceInfo provides fields associated with a DataSource
type DataSourceInfo struct {
	Title          string
	TitleShort     string
	Description    string
	UUID           string
	HomeURL        string
	DataURL        string
	IsOutlinkReady bool
	OutlinkURL     string
	OutlinkID      func(n NameInfo) string
	*Meta
}

// Meta provides explanation what different fields
// mean for particular data-sources.
type Meta struct {
	RecordID string
	LocalID  string
	GlobalID string
}

// NameInfo provides fields associated with a name-string in a particular
// data source. It is used to create outlink methods.
type NameInfo struct {
	RecordID         string
	AcceptedRecordID string
	LocalID          string
	GlobalID         string
	Canonical        string
	CanonicalFull    string
}

var (
	// curatedAry is list of data-source IDs were (as we believe) data is
	// curated by a specialist to a significant degree.
	curatedAry = []int{1, 2, 3, 5, 6, 9, 105, 132, 151, 155,
		163, 165, 167, 172, 173, 174, 175, 176, 177, 181, 183, 184, 185,
		187, 188, 189, 193, 195, 197, 201, 203, 204, 205, 208, 209}

	// autoCuratedAry is a list of data-source IDs where (as we believe)
	// data is checked by scripts to a substational degree.
	autoCuratedAry = []int{11, 12, 158, 170, 179, 186, 194, 196, 206, 207}

	// hasClassifAry contains list of data-source IDs where there is
	// a classification data associated with a name.
	hasClassifAry = []int{1, 3, 5, 6, 7, 8, 9, 10, 11, 112, 124, 126, 129,
		131, 136, 137, 140, 141, 143, 144, 147, 148, 152, 154, 156, 157, 158, 161,
		163, 170, 172, 174, 175, 181, 182, 184, 193, 195, 196, 197, 198, 202,
		204, 208, 209}
)

// DataSourcesInfoMap provides missing data for data_sources table.
var DataSourcesInfoMap = map[int]DataSourceInfo{
	1: {
		Title:          "Catalogue of Life",
		TitleShort:     "Catalogue of Life",
		UUID:           "d4df2968-4257-4ad9-ab81-bedbbfb25e2a",
		HomeURL:        "https://www.catalogueoflife.org/",
		DataURL:        "http://www.catalogueoflife.org/DCA_Export/archive.php",
		IsOutlinkReady: true,
		OutlinkURL:     "https://www.catalogueoflife.org/data/taxon/{}",
		OutlinkID: func(n NameInfo) string {
			return n.RecordID
		},
		Meta: &Meta{
			RecordID: "Identifier of a taxon",
		},
	},
	2: {
		TitleShort:     "Wikispecies",
		UUID:           "68923690-0727-473c-b7c5-2ae9e601e3fd",
		HomeURL:        "https://species.wikimedia.org/wiki/Main_Page",
		IsOutlinkReady: true,
		DataURL: "http://dumps.wikimedia.org/specieswiki/latest/" +
			"specieswiki-latest-pages-articles.xml.bz2",
		OutlinkURL: "http://species.wikimedia.org/wiki/{}",
		OutlinkID: func(n NameInfo) string {
			return strings.ReplaceAll(n.CanonicalFull, " ", "_")
		},
	},
	3: {
		Title:          "Integrated Taxonomic Information System",
		TitleShort:     "ITIS",
		UUID:           "5d066e84-e512-4a2f-875c-0a605d3d9f35",
		HomeURL:        "https://www.itis.gov/",
		DataURL:        "https://www.itis.gov/downloads/itisMySQLTables.tar.gz",
		IsOutlinkReady: true,
		OutlinkURL:     "https://www.itis.gov/servlet/SingleRpt/SingleRpt?search_topic=TSN&search_value={}#null",
		OutlinkID: func(n NameInfo) string {
			return n.RecordID
		},
	},
	4: {
		Title:          "National Center for Biotechnology Information",
		TitleShort:     "NCBI",
		UUID:           "97d7633b-5f79-4307-a397-3c29402d9311",
		HomeURL:        "https://www.ncbi.nlm.nih.gov/",
		DataURL:        "ftp://ftp.ncbi.nih.gov/pub/taxonomy/taxdump.tar.gz",
		IsOutlinkReady: true,
		OutlinkURL: "https://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?" +
			"mode=Undef&name={}&lvl=0&srchmode=1&keep=1&unlock",
		OutlinkID: func(n NameInfo) string {
			return url.PathEscape(n.Canonical)
		},
	},
	5: {
		Title:          "Index Fungorum: Species Fungorum",
		TitleShort:     "Index Fungorum",
		UUID:           "af06816a-0b28-4a09-8219-bd1d63289858",
		HomeURL:        "http://www.speciesfungorum.org",
		IsOutlinkReady: true,
		OutlinkURL:     "http://www.indexfungorum.org/Names/NamesRecord.asp?RecordID={}",
		OutlinkID: func(n NameInfo) string {
			return n.RecordID
		},
	},
	8: {
		TitleShort: "IRMNG (old)",
		UUID:       "f8e586aa-876e-4b0a-ab89-da0b4a64c19a",
		HomeURL:    "https://irmng.org/",
	},
	9: {
		TitleShort:     "WoRMS",
		UUID:           "bf077d91-673a-4be4-8af9-76db45d07e98",
		IsOutlinkReady: true,
		HomeURL:        "https://marinespecies.org",
		OutlinkURL:     "https://www.marinespecies.org/aphia.php?p=taxdetails&id={}",
		OutlinkID: func(n NameInfo) string {
			id := n.RecordID
			el := strings.Split(id, ":")
			if len(el) == 0 {
				return ""
			}
			return el[len(el)-1]
		},
	},
	10: {
		TitleShort: "Freebase",
		UUID:       "bacd21f0-44e0-43e2-914c-70929916f257",
	},
	11: {
		Title:          "Global Biodiversity Information Facility Backbone Taxonomy",
		TitleShort:     "GBIF Backbone Taxonomy",
		UUID:           "eebb6f49-e1a1-4f42-b9d5-050844c893cd",
		IsOutlinkReady: true,
		HomeURL:        "https://www.gbif.org/dataset/d7dddbf4-2cf0-4f39-9b2a-bb099caae36c",
		OutlinkURL:     "https://gbif.org/species/{}",
		OutlinkID: func(n NameInfo) string {
			return n.RecordID
		},
	},
	12: {
		TitleShort:     "EOL",
		UUID:           "dba5f880-a40d-479b-a1ad-a646835edde4",
		HomeURL:        "https://eol.org",
		DataURL:        "https://eol.org/data/provider_ids.csv.gz",
		IsOutlinkReady: true,
		OutlinkURL:     "https://eol.org/pages/{}",
		OutlinkID: func(n NameInfo) string {
			return n.RecordID
		},
	},
	113: {
		Title:      "Zoological names",
		TitleShort: "Zoological names",
	},
	117: {
		Title:      "Birds of Tansania",
		TitleShort: "Birds of Tansania",
	},
	119: {
		Title:      "Tansania Plant Specimens",
		TitleShort: "Tansania Plant Specimens",
	},
	142: {
		Title:      "The Clements Checklist of Birds of the World",
		TitleShort: "The Clements Checklist of Birds",
	},
	147: {
		TitleShort: "VASCAN",
	},
	149: {
		Title:      "Ocean Biodiversity Information System",
		TitleShort: "OBIS",
	},
	155: {
		TitleShort: "FishBase",
		UUID:       "bacd21f0-44e0-43e2-914c-70929916f257",
		HomeURL:    "https://www.fishbase.in/home.htm",
	},
	158: {
		Title:          "European Nature Information System",
		TitleShort:     "EUNIS",
		Description:    "Find species, habitat types and protected sites across Europe ",
		HomeURL:        "https://eunis.eea.europa.eu/",
		IsOutlinkReady: true,
		OutlinkURL:     "https://eunis.eea.europa.eu/species/{}",
		OutlinkID: func(n NameInfo) string {
			return n.RecordID
		},
	},
	165: {
		TitleShort: "Tropicos",
		Description: "The Tropicos database links over 1.33M scientific names " +
			"with over 4.87M specimens and over 685K digital images. The data " +
			"includes over 150K references from over 52.6K publications offered " +
			"as a free service to the world’s scientific community.",
		IsOutlinkReady: true,
		OutlinkURL:     "https://tropicos.org/name/{}",
		OutlinkID: func(n NameInfo) string {
			return n.RecordID
		},
	},
	167: {
		TitleShort:     "IPNI",
		UUID:           "6b3905ce-5025-49f3-9697-ddd5bdfb4ff0",
		HomeURL:        "https://www.ipni.org/",
		IsOutlinkReady: true,
		OutlinkURL:     "https://www.ipni.org/n/{}",
		OutlinkID: func(n NameInfo) string {
			return n.RecordID
		},
	},
	168: {
		TitleShort:     "ION",
		UUID:           "1137dfa3-5b8c-487d-b497-dc0938605864",
		HomeURL:        "http://organismnames.com/",
		IsOutlinkReady: true,
		OutlinkURL:     "http://www.organismnames.com/details.htm?lsid={}",
		OutlinkID: func(n NameInfo) string {
			return n.RecordID
		},
	},
	170: {
		TitleShort:     "Arctos",
		UUID:           "eea8315d-a244-4625-859a-226675622312",
		HomeURL:        "https://arctosdb.org/",
		IsOutlinkReady: true,
		OutlinkURL:     "https://arctos.database.museum/name/{}",
		OutlinkID: func(n NameInfo) string {
			return url.QueryEscape(n.CanonicalFull)
		},
	},
	172: {
		TitleShort: "PaleoBioDB",
		UUID:       "fad9970e-c358-4e1b-8cc3-f9ad2582751f",
		HomeURL:    "https://paleobiodb.org/#/",
	},
	173: {
		TitleShort: "The Reptile DataBase",
		UUID:       "c24e0905-4980-4e1d-aff2-ee0ef54ea1f8",
		HomeURL:    "http://reptile-database.org/",
	},
	174: {
		TitleShort:     "Mammal Species of the World",
		UUID:           "464dafec-1037-432d-8449-c0b309e0a030",
		HomeURL:        "https://www.departments.bucknell.edu/biology/resources/msw3/",
		DataURL:        "https://www.departments.bucknell.edu/biology/resources/msw3/export.asp",
		IsOutlinkReady: true,
		OutlinkURL:     "https://www.departments.bucknell.edu/biology/resources/msw3/browse.asp?s=y&id={}",
		OutlinkID: func(n NameInfo) string {
			return n.LocalID
		},
	},
	175: {
		TitleShort:     "BirdLife International",
		UUID:           "b1d8de7a-ab96-455f-acd8-f3fff2d7d169",
		HomeURL:        "http://www.birdlife.org/",
		DataURL:        "http://datazone.birdlife.org/species/taxonomy",
		IsOutlinkReady: true,
		OutlinkURL:     "http://datazone.birdlife.org/species/results?thrlev1=&thrlev2=&kw={}",
		OutlinkID: func(n NameInfo) string {
			return url.PathEscape(n.Canonical)
		},
	},
	179: {
		TitleShort: "Open Tree of Life",
		UUID:       "e10865e2-cdd9-4f97-912f-08f3d5ef49f7",
		HomeURL:    "https://tree.opentreeoflife.org/",
		DataURL:    "https://files.opentreeoflife.org/ott/",
	},
	180: {
		TitleShort:     "iNaturalist",
		UUID:           "e26d2a88-0f46-40c1-8cf4-997274e3a495",
		IsOutlinkReady: true,
		HomeURL:        "https://inaturalist.org/",
		DataURL:        "https://www.inaturalist.org/taxa/inaturalist-taxonomy.dwca.zip",
		OutlinkURL:     "https://www.inaturalist.org/taxa/{}",
		OutlinkID: func(n NameInfo) string {
			return n.RecordID
		},
	},
	181: {
		TitleShort: "IRMNG",
		UUID:       "417454fa-a0a1-4b9c-814d-edc0f4f25ad8",
		HomeURL:    "https://irmng.org/",
		DataURL:    "https://irmng.org/export/",
	},
	183: {
		TitleShort:     "Sherborn Index Animalium",
		UUID:           "05ad6ca2-fc37-47f4-983a-72e535420e28",
		IsOutlinkReady: true,
		HomeURL:        "https://www.sil.si.edu/DigitalCollections/indexanimalium/taxonomicnames/",
		DataURL: "https://www.sil.si.edu/DigitalCollections/indexanimalium/" +
			"Datasets/2006.01.06.TaxonomicData.csv",
	},
	184: {
		TitleShort:     "ASM Mammal Diversity DB",
		UUID:           "94270cdd-5424-4bb1-8324-46ccc5386dc7",
		HomeURL:        "https://mammaldiversity.org/",
		DataURL:        "https://mammaldiversity.org/",
		IsOutlinkReady: true,
		OutlinkURL:     "https://mammaldiversity.org/species-account/species-id={}",
		OutlinkID: func(n NameInfo) string {
			return n.AcceptedRecordID
		},
	},
	185: {
		TitleShort: "IOC World Bird List",
		UUID:       "6421ffec-38e3-40fb-a6d9-af27238a47a1",
		HomeURL:    "https://www.worldbirdnames.org/",
		DataURL:    "https://www.worldbirdnames.org/ioc-lists/master-list-2/",
	},
	186: {
		TitleShort:     "MCZbase",
		UUID:           "c79d055b-211b-40de-8e27-618011656265",
		IsOutlinkReady: true,
		HomeURL:        "https://mczbase.mcz.harvard.edu/",
		OutlinkURL:     "https://mczbase.mcz.harvard.edu/name/{}",
		OutlinkID: func(n NameInfo) string {
			return url.PathEscape(n.Canonical)
		},
	},
	187: {
		TitleShort: "Clements' Birds of the World",
		UUID:       "577c0b56-4a3c-4314-8724-14b304f601de",
		HomeURL:    "https://www.birds.cornell.edu/clementschecklist/",
		DataURL:    "https://www.birds.cornell.edu/clementschecklist/download/",
	},
	188: {
		TitleShort:     "American Ornithological Society",
		UUID:           "91d38806-8435-479f-a18d-705e5cb0767c",
		HomeURL:        "https://americanornithology.org/",
		IsOutlinkReady: true,
		DataURL:        "https://checklist.americanornithology.org/taxa.csv",
		OutlinkURL:     "https://checklist.americanornithology.org/taxa/{}",
		OutlinkID: func(n NameInfo) string {
			return n.RecordID
		},
	},
	189: {
		TitleShort: "Howard & Moore Birds of the World",
		UUID:       "85023fe5-bf2a-486b-bdae-3e61cefd41fd",
		HomeURL:    "https://www.howardandmoore.org/",
		DataURL:    "https://www.howardandmoore.org/howard-and-moore-database/",
	},
	193: {
		Title:          "Myriatrix",
		TitleShort:     "Myriatrix",
		HomeURL:        "http://myriatrix.myspecies.info",
		IsOutlinkReady: true,
		OutlinkURL:     "https://myriatrix.myspecies.info/myriatrix/{}",
		OutlinkID: func(n NameInfo) string {
			name := strings.ToLower(n.CanonicalFull)
			name = strings.ReplaceAll(name, " ", "-")
			name = strings.ReplaceAll(name, ".", "")
			return name
		},
	},
	194: {
		TitleShort:     "Plazi",
		UUID:           "68938dc9-b93d-43bc-9d51-5c2a632f136f",
		HomeURL:        "https://www.plazi.org/",
		IsOutlinkReady: true,
		DataURL:        "http://tb.plazi.org/GgServer/xml.rss.xml",
		OutlinkURL:     "http://tb.plazi.org/GgServer/html/{}",
		OutlinkID: func(n NameInfo) string {
			return n.LocalID
		},
	},
	195: {
		TitleShort:     "AlgaeBase",
		UUID:           "a5869bfb-7cbf-40f2-88d3-962922dac43f",
		HomeURL:        "https://www.algaebase.org/",
		IsOutlinkReady: true,
		OutlinkURL:     "https://www.algaebase.org/search/species/detail/?species_id={}",
		OutlinkID: func(n NameInfo) string {
			return n.RecordID
		},
	},
	196: {
		TitleShort:     "World Flora Online",
		UUID:           "39e7b959-9b16-460c-a77f-71934b7098e0",
		HomeURL:        "http://www.worldfloraonline.org",
		Description:    "An Online Flora of All Known Plants",
		IsOutlinkReady: true,
		OutlinkURL:     "http://www.worldfloraonline.org/taxon/{}",
		OutlinkID: func(n NameInfo) string {
			return n.RecordID
		},
	},
	197: {
		TitleShort:     "World Checklist of Vascular Plants",
		UUID:           "814d1a77-2234-449b-af4a-138e0e1b1326",
		HomeURL:        "https://wcvp.science.kew.org/",
		DataURL:        "https://sftp.kew.org/pub/data-repositories/WCVP/wcvp_dwca.zip",
		IsOutlinkReady: true,
		OutlinkURL:     "https://powo.science.kew.org/taxon/urn:lsid:ipni.org:names:{}",
		OutlinkID: func(n NameInfo) string {
			return n.RecordID
		},
	},
	198: {
		TitleShort: "Leipzig Cat. Vasc. Plants",
		UUID:       "75fb6846-4c37-4b45-a2ab-05dc0124957b",
		HomeURL:    "https://github.com/idiv-biodiversity/LCVP",
	},
	200: {
		TitleShort: "Terrestrial Parasite Tracker",
		UUID:       "75886826-50f9-4513-916d-3ab4875cb063",
		HomeURL:    "https://github.com/njdowdy/tpt-taxonomy",
	},
	201: {
		TitleShort:     "ICTV Virus Taxonomy",
		UUID:           "e090da49-8feb-4e03-aff6-a0aa50c4dc37",
		HomeURL:        "https://talk.ictvonline.org/taxonomy",
		IsOutlinkReady: true,
		OutlinkURL:     "https://talk.ictvonline.org/taxonomy/p/taxonomy-history?taxnode_id={}",
		OutlinkID: func(n NameInfo) string {
			return n.LocalID
		},
	},
	202: {
		TitleShort: "Discover Life Bees",
		UUID:       "7911b6d6-9029-496f-b3a7-7e233199c1d7",
		HomeURL:    "http://www.discoverlife.org/mp/20q?act=x_checklist&guide=Apoidea_species",
	},
	203: {
		TitleShort:     "MycoBank",
		UUID:           "b0ac4f6f-fc56-41b4-ad69-6af30a881e7e",
		HomeURL:        "https://www.mycobank.org",
		IsOutlinkReady: true,
		OutlinkURL:     "https://www.mycobank.org/page/Name details page/{}",
		OutlinkID: func(n NameInfo) string {
			return n.RecordID
		},
	},
	204: {
		TitleShort:     "Fungal Names",
		UUID:           "4b373ccd-2f47-4c43-81c3-c2402360fd43",
		HomeURL:        "https://nmdc.cn/fungalnames",
		IsOutlinkReady: true,
		OutlinkURL:     "https://nmdc.cn/fungalnames/namesearch/toallfungalinfo?recordNumber={}",
		OutlinkID: func(n NameInfo) string {
			return n.RecordID
		},
	},
	205: {
		TitleShort: "Nomenclator Zoologicus",
		UUID:       "02fd9b10-78e4-43a5-889e-0639a771c576",
		HomeURL:    "https://doi.org/10.5281/zenodo.7010676",
	},
	206: {
		TitleShort: "Ruhoff 1980",
		UUID:       "5413758a-7fd8-4db9-b06b-f780f8688f2a",
		HomeURL:    "https://doi.org/10.5479/si.00810282.294",
	},
	207: {
		TitleShort:     "Wikidata",
		UUID:           "f972c3e7-9da8-48d1-aa00-5c6c56c24614",
		HomeURL:        "https://wikidata.org",
		DataURL:        "https://www.wikidata.org/wiki/Wikidata:Database_download",
		IsOutlinkReady: true,
		OutlinkURL:     "https://wikidata.org/wiki/{}",
		OutlinkID: func(n NameInfo) string {
			return n.RecordID
		},
	},
	208: {
		TitleShort:     "LPSN",
		UUID:           "3d10ba04-be3a-4617-b9d5-07f1ae5ac195",
		HomeURL:        "https://lpsn.dsmz.de/",
		DataURL:        "https://lpsn.dsmz.de/downloads",
		IsOutlinkReady: true,
		OutlinkURL:     "{}",
		OutlinkID: func(n NameInfo) string {
			return n.LocalID
		},
	},
	209: {
		TitleShort:     "NZOR",
		UUID:           "365ee637-7189-4551-a52a-74aa79d3ee2f",
		HomeURL:        "https://www.nzor.org.nz/",
		DataURL:        "https://www.nzor.org.nz/downloads",
		IsOutlinkReady: true,
		OutlinkURL:     "https://www.nzor.org.nz/names/{}",
		OutlinkID: func(n NameInfo) string {
			return n.RecordID
		},
	},
}

func IsCurated(id int) bool {
	_, curated := slices.BinarySearch(curatedAry, id)
	return curated
}

func IsAutoCurated(id int) bool {
	_, curated := slices.BinarySearch(autoCuratedAry, id)
	return curated
}

func HasClassification(id int) bool {
	_, classif := slices.BinarySearch(hasClassifAry, id)
	return classif
}
