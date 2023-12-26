CREATE SCHEMA "Kisi";

CREATE TABLE "Kisi"."Kisi" (
  kisi_id serial unique not null,
  ad varchar(50),
  soyad varchar(50),
  dogum_tarihi date,
  cinsiyet char(1)
)
CREATE TABLE "Kisi"."TeknikDirektor" (
	teknik_direktor_id int unique not null,
	gorev_baslangic_tarihi date,
	gorev_bitis_tarihi date,
	kazanilan_kupa_sayisi int,
	takim_id int,
	CONSTRAINT "teknikDirektorPK" PRIMARY KEY ("teknik_direktor_id")
)
CREATE TABLE "Kisi"."Yonetici" (
	yonetici_id int unique not null,
	gorevi varchar(50),
	CONSTRAINT "yoneticiPK" PRIMARY KEY ("yonetici_id")
)
ALTER TABLE "Kisi"."Yonetici"
	ADD CONSTRAINT "KisiYonetici" FOREIGN KEY ("yonetici_id")
	REFERENCES "Kisi"."Kisi" ("kisi_id")
	ON DELETE CASCADE
	ON UPDATE CASCADE;
ALTER TABLE "Kisi"."TeknikDirektor"
	ADD CONSTRAINT "KisiTeknikDirektor" FOREIGN KEY ("direktor_id")
	REFERENCES "Kisi"."Kisi" ("kisi_id")
	ON DELETE CASCADE
	ON UPDATE CASCADE;
CREATE TABLE "Kisi"."Oyuncu" (
	oyuncu_id int unique not null,
	mevki varchar(15),
	mac_sayisi smallint,
	gol_sayisi smallint,
	forma_numarasi smallint check(forma_numarasi>=1 AND forma_numarasi<= 99),
	CONSTRAINT "oyuncuPK" PRIMARY KEY ("oyuncu_id")
);
ALTER TABLE "Kisi"."Oyuncu"
	ADD CONSTRAINT "KisiOyuncu" FOREIGN KEY ("oyuncu_id")
	REFERENCES "Kisi"."Kisi" ("kisi_id")
	ON DELETE CASCADE
	ON UPDATE CASCADE;
CREATE TABLE "Kisi"."Hakem" (
	hakem_id int unique not null,
	CONSTRAINT "hakemPK" PRIMARY KEY ("hakem_id")
);
ALTER TABLE "Kisi"."Hakem"
	ADD CONSTRAINT "KisiHakem" FOREIGN KEY ("hakem_id")
	REFERENCES "Kisi"."Kisi" ("kisi_id")
	ON DELETE CASCADE
	ON UPDATE CASCADE;
create table "Sehir"(
	sehir_id serial unique not null,
	sehir_adi varchar(100),
	nufus int,
	constraint "sehirPK" primary key ("sehir_id")
);
CREATE TABLE "Stadyum"(
	stadyum_id serial unique not null,
	stadyum_adi varchar(100),
	kapasite smallint,
	sehir_id int not null,
	CONSTRAINT "stadyumPK" PRIMARY KEY ("stadyum_id"),
	CONSTRAINT "sehirFK" FOREIGN KEY ("sehir_id") REFERENCES "Sehir"("sehir_id")
);
CREATE TABLE "Federasyon"(
	federasyon_id serial unique not null,
	federasyon_adi varchar(100),
	ulke varchar(50),
	CONSTRAINT "federasyonPK" PRIMARY KEY ("federasyon_id")
);
CREATE TABLE "Lig"(
	lig_id serial unique not null,
	lig_adi varchar(100),
	sezon_yili char(4),
	CONSTRAINT "ligPK" PRIMARY KEY ("lig_id")
);
CREATE TABLE "Takim" (
	takim_id serial unique not null,
	takim_adi varchar(100),
	kurulus_yili date,
	federasyon_id int,
	stadyum_id int not null,
	teknik_direktor_id int,
	CONSTRAINT "takimPK" PRIMARY KEY ("takim_id"),
	CONSTRAINT "teknik_direktor_idFK" FOREIGN KEY("teknik_direktor_id") REFERENCES "Kisi"."TeknikDirektor"("teknik_direktor_id")
);
alter table "Kisi"."TeknikDirektor" add constraint "takim_idFK" foreign key ("takim_id") references "Takim"("takim_id");
CREATE TABLE "Kupa" (
  kupa_id serial unique not null,
  kupa_adi varchar(50),
  takim_id int not null,
  tarih date,
  CONSTRAINT "kupaPK" PRIMARY KEY ("kupa_id"),
	CONSTRAINT "takim_adiFK" FOREIGN KEY ("takim_id") REFERENCES "Takim"("takim_id")
);
CREATE TABLE "TakimLig" (
  takim_lig_id serial unique not null,
  lig_id int not null,
  takim_id int not null,
  tarih date,
  CONSTRAINT "takimLigPK" PRIMARY KEY ("takim_lig_id","takim_id","lig_id"),
	CONSTRAINT "takim_adiFK" FOREIGN KEY ("takim_id") REFERENCES "Takim"("takim_id"),
	CONSTRAINT "lig_idFK" FOREIGN KEY ("lig_id") REFERENCES "Lig"("lig_id")
);
CREATE TABLE "Sponsor" (
  sponsor_id serial unique not null,
  sirket_adi varchar(50),
  sponsorluk_baslangic_tarihi date,
  sponsorluk_bitis_tarihi date,
	takim_id int not null,
  CONSTRAINT "sponsorPK" PRIMARY KEY ("sponsor_id","takim_id"),
	CONSTRAINT "takim_idFK" FOREIGN KEY ("takim_id") REFERENCES "Takim"("takim_id")
);
CREATE TABLE "Antrenman" (
    antrenman_id serial unique not null,
    tarih date,
	antrenman_turu varchar(20),
	stadyum_id int not null,
	takim_id int not null,
    CONSTRAINT "antrenmanPK" PRIMARY KEY ("antrenman_id","takim_id","stadyum_id"),
	CONSTRAINT "takim_idFK" FOREIGN KEY ("takim_id") REFERENCES "Takim"("takim_id"),
	CONSTRAINT "stadyum_idFK" FOREIGN KEY ("stadyum_id") REFERENCES "Stadyum"("stadyum_id")
);
CREATE TABLE "TakimYonetici" (
    takim_yonetici_id serial unique not null,
    yonetici_id int not null,
	takim_id int not null,
	baslangic_tarihi date,
	bitis_tarihi date,
    CONSTRAINT "takimYoneticiPK" PRIMARY KEY ("takim_yonetici_id","takim_id","yonetici_id"),
	CONSTRAINT "takim_idFK" FOREIGN KEY ("takim_id") REFERENCES "Takim"("takim_id"),
	CONSTRAINT "yonetici_idFK" FOREIGN KEY ("yonetici_id") REFERENCES "Kisi"."Yonetici"("yonetici_id")
);
CREATE TABLE "Transfer" (
    transfer_id serial unique not null,
    oyuncu_id int not null,
	eski_takim_id int,
	yeni_takim_id int not null,
	transfer_tarihi date,
    CONSTRAINT "transferPK" PRIMARY KEY ("transfer_id","oyuncu_id"),
	CONSTRAINT "eski_takim_idFK" FOREIGN KEY ("eski_takim_id") REFERENCES "Takim"("takim_id"),
	CONSTRAINT "yeni_takim_idFK" FOREIGN KEY ("yeni_takim_id") REFERENCES "Takim"("takim_id"),
	CONSTRAINT "oyuncu_idFK" FOREIGN KEY ("oyuncu_id") REFERENCES "Kisi"."Oyuncu"("oyuncu_id")
);
CREATE TABLE "Renk" (
    renk_id serial unique not null,
    hex_kodu char(7),
    CONSTRAINT "renkPK" PRIMARY KEY ("renk_id")
);
CREATE TABLE "TakimRenk" (
	takim_renk_id serial unique not null,
    renk_id int not null,
    takim_id int not null,
    CONSTRAINT "takimRenkPK" PRIMARY KEY ("takim_renk_id","renk_id","takim_id")
);
CREATE TABLE "Mac" (
	mac_id serial unique not null,
    ev_sahibi_takim_id int not null,
    deplasman_takim_id int not null,
    tarih date not null,
	sonuc varchar(20),
	stadyum_id int not null,
	hakem_id int not null,
    CONSTRAINT "macPK" PRIMARY KEY ("mac_id","tarih","ev_sahibi_takim_id","deplasman_takim_id","stadyum_id","hakem_id"),
	CONSTRAINT "ev_sahibi_takim_idFK" FOREIGN KEY ("ev_sahibi_takim_id") REFERENCES "Takim"("takim_id"),
	CONSTRAINT "deplasman_takim_idFK" FOREIGN KEY ("deplasman_takim_id") REFERENCES "Takim"("takim_id"),
	CONSTRAINT "stadyum_idFK" FOREIGN KEY ("stadyum_id") REFERENCES "Stadyum"("stadyum_id"),
	CONSTRAINT "hakem_idFK" FOREIGN KEY ("hakem_id") REFERENCES "Kisi"."Hakem"("hakem_id")
);
CREATE TABLE "MacHakem" (
	mac_hakem_id serial unique not null,
	hakem_id int not null,
	mac_id int not null,
    CONSTRAINT "macHakemPK" PRIMARY KEY ("mac_hakem_id","hakem_id","mac_id"),
	CONSTRAINT "mac_idFK" FOREIGN KEY ("mac_id") REFERENCES "Mac"("mac_id"),
	CONSTRAINT "hakem_idFK" FOREIGN KEY ("hakem_id") REFERENCES "Kisi"."Hakem"("hakem_id")
);