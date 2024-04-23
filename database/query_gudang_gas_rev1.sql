-- menentukan operasi yang akan dialokasikan kebutuhan gas
SELECT 
	operasi.id_operasi AS 'operation ID',
	operasi.id_product AS 'product ID',
    detail_bpm.id_jenis_gas AS 'gas ID',
    operasi.estStartTime AS 'estStart',
    operasi.estFinishTime AS 'estFinish'
FROM
    operasi
JOIN
    detail_bpm ON operasi.id_product = detail_bpm.id_bpm

-- menentukan kebutuhan total gas
SELECT 
    jenis_tabung.jenis_tabung,
    COALESCE(SUM(detail_bpm.kuantitas), 0) AS quantity_needed,
    COALESCE(SUM(detail_bprm.kuantitas), 0) AS quantity_stock,
    COALESCE(SUM(detail_bpm.kuantitas), 0) - COALESCE(SUM(detail_bprm.kuantitas), 0) AS order_quantity
FROM 
    detail_bpm
LEFT JOIN jenis_tabung ON detail_bpm.id_jenis_gas = jenis_tabung.id_jenis_tabung
LEFT JOIN detail_bprm ON detail_bpm.id_jenis_gas = detail_bprm.id_jenis_tabung
GROUP BY jenis_tabung.jenis_tabung;

-- Query untuk menentukan alokasi kebutuhan gas
SELECT hm.id_lokasi AS lokasi,
       o.estStartTime,
       db.kuantitas AS quantity_kebutuhan,
       db.id_jenis_gas AS gas_id
FROM history_mutasi hm
JOIN operasi o ON hm.id_operasi = o.id_operasi
JOIN detail_bpm db ON hm.bpm_id_bpm = db.id_bpm;

-- Query untuk menentukan pengadaan kebutuhan gas
SELECT hm.id_lokasi AS lokasi,
       SUM(db.kuantitas) AS quantity_kebutuhan,
       t.id_tabung AS stock_tabung_id,
       db.id_jenis_gas AS gas_id
FROM history_mutasi hm
JOIN detail_bpm db ON hm.bpm_id_bpm = db.id_bpm
JOIN tabung t ON db.id_jenis_gas = t.id_jenis_tabung
GROUP BY hm.id_lokasi, db.id_jenis_gas, t.id_tabung;