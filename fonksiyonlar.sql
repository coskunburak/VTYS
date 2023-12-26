CREATE OR REPLACE FUNCTION toplam_oyuncu_sayisi()
RETURNS INTEGER AS $$
DECLARE
    oyuncu_sayisi INTEGER;
BEGIN
    SELECT COUNT(*) INTO oyuncu_sayisi FROM "Kisi"."Oyuncu";
    RETURN oyuncu_sayisi;
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION tarihe_gore_mac_listele(tarih DATE)
RETURNS TABLE (mac_idd INT, ev_sahibi_takim VARCHAR(255), deplasman_takim VARCHAR(255))
AS
$$
BEGIN
    RETURN QUERY
    SELECT mac_id, (SELECT takim_adi FROM "Takim" WHERE takim_id = ev_sahibi_takim_id),
                   (SELECT takim_adi FROM "Takim" WHERE takim_id = deplasman_takim_id)
    FROM "Mac"
    WHERE tarih = tarih;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION SayOyuncununTakimindakiOyuncular(
    IN oyuncu_idd INT
)
RETURNS INT
AS $$
DECLARE
    oyuncu_sayisi INT;
BEGIN
    SELECT COUNT(*)
    INTO oyuncu_sayisi
    FROM "Kisi"."Oyuncu"
    WHERE oynanan_takim_id = (SELECT oynanan_takim_id FROM "Kisi"."Oyuncu" WHERE oyuncu_idd = oyuncu_id);

    RETURN oyuncu_sayisi;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION mac_ekle(
    p_ev_sahibi_takim_id INTEGER,
    p_deplasman_takim_id INTEGER,
    p_tarih DATE,
    p_sonuc VARCHAR(255),
    p_stadyum_id INTEGER,
    p_hakem_id INTEGER
)
RETURNS INTEGER
AS $$
DECLARE
    v_mac_id INTEGER;
BEGIN
    -- Kontroller
    IF NOT EXISTS (SELECT 1 FROM "Takim" WHERE takim_id = p_ev_sahibi_takim_id) THEN
        RAISE EXCEPTION 'Ev sahibi takım bulunamadı.';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM "Takim" WHERE takim_id = p_deplasman_takim_id) THEN
        RAISE EXCEPTION 'Deplasman takımı bulunamadı.';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM "Stadyum" WHERE stadyum_id = p_stadyum_id) THEN
        RAISE EXCEPTION 'Stadyum bulunamadı.';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM "Kisi"."Hakem" WHERE hakem_id = p_hakem_id) THEN
        RAISE EXCEPTION 'Hakem bulunamadı.';
    END IF;

    -- Maç ekleme
    INSERT INTO "Mac" (
        ev_sahibi_takim_id,
        deplasman_takim_id,
        tarih,
        sonuc,
        stadyum_id,
        hakem_id
    )
    VALUES (
        p_ev_sahibi_takim_id,
        p_deplasman_takim_id,
        p_tarih,
        p_sonuc,
        p_stadyum_id,
        p_hakem_id
    )
    RETURNING mac_id INTO v_mac_id;

    RETURN v_mac_id;
END;
$$ LANGUAGE plpgsql;