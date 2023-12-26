CREATE OR REPLACE FUNCTION artir_mac_sayisi()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE "Kisi"."Oyuncu"
    SET mac_sayisi = mac_sayisi + 1
    WHERE oyuncu_id IN (NEW.ev_sahibi_takim_id, NEW.deplasman_takim_id);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER yeni_mac_eklendiginde
AFTER INSERT ON "Mac"
FOR EACH ROW
EXECUTE FUNCTION artir_mac_sayisi();

CREATE OR REPLACE FUNCTION yeni_oyuncu_transfer_function()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO "Transfer" (oyuncu_id, eski_takim_id, yeni_takim_id, transfer_tarihi)
    VALUES (NEW.oyuncu_id, NULL, NEW.oynanan_takim_id, NOW());
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER yeni_oyuncu_transfer
AFTER INSERT ON "Kisi"."Oyuncu"
FOR EACH ROW
EXECUTE FUNCTION yeni_oyuncu_transfer_function();

CREATE OR REPLACE FUNCTION kontrolmactarihi()
RETURNS TRIGGER
AS $$
BEGIN
    IF NEW.tarih > CURRENT_DATE THEN
        RAISE EXCEPTION 'İleri tarihli bir maç eklenemez.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER mac_tarihi_kontrol
BEFORE INSERT OR UPDATE ON "Mac"
FOR EACH ROW
EXECUTE FUNCTION kontrolmactarihi();

CREATE OR REPLACE FUNCTION KontrolStadyumAtama()
RETURNS TRIGGER
AS $$
BEGIN
    IF NEW.stadyum_id IS NULL THEN
        RAISE EXCEPTION 'Her maç için bir stadyum atanmalıdır.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER stadyum_atama_kontrol
BEFORE INSERT OR UPDATE ON "Mac"
FOR EACH ROW
EXECUTE FUNCTION KontrolStadyumAtama();
