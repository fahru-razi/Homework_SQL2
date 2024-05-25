/* Soal 1
Tim Risk sedang melakukan investigasi untuk pelanggan
yang menggunakan email Yahoo ataupun Roketmail, khususnya
yang melakukan registrasi di kuartal 1 (Januari - Maret) tahun
2012 dan juga berulang tahun antara Januari - Maret.
Tampilkan informasi nama, email, bulan lahir, dan tanggal registrasi dari
pelanggan yang memenuhi kriteria tersebut! */
SELECT 
	nama, 
	email, 
	bulan_lahir, 
	tanggal_registrasi 
FROM rakamin_customer 
WHERE 
	(email LIKE '%yahoo%' OR email LIKE '%roketmail%')
	AND tanggal_registrasi BETWEEN '2012-01-01' AND '2012-03-31' 
	AND bulan_lahir IN ('Januari','Februari', 'Maret');
	
/* Soal 2
Tim Business ingin menganalisis perilaku spending dari para pelanggan
dengan cara mengkategorikan setiap transaksi menjadi beberapa bucket
menurut jumlah uang yang dikeluarkan oleh pelanggan. Spending bucket
yang didefinisikan oleh tim Business adalah LOW (untuk jumlah transaksi
setelah PPN tidak melebihi 20 ribu), MEDIUM (untuk jumlah transaksi
setelah PPN lebih dari 20 ribu dan tidak melebihi 50 ribu) dan HIGH (untuk
jumlah transaksi setelah PPN di atas 50 ribu). Tampilkan informasi id_order,
id_pelanggan, harga, harga setelah PPN dan spending_bucket sesuai
kriteria dari tim Business kemudian urutkan berdasarkan harga setelah
PPN dari yang paling besar.*/
SELECT
	id_order, 
	id_pelanggan, 
	harga, 
	(harga * 1.1) AS harga_setelah_ppn,
	CASE
    	WHEN (harga * 1.1) <= 20000 THEN 'LOW'
    	WHEN (harga * 1.1) > 20000 AND (harga * 1.1) <= 50000 THEN 'MEDIUM'
    	ELSE 'HIGH'
	END AS spending_bucket
FROM rakamin_order
ORDER BY harga_setelah_ppn DESC;

/* Soal 3
Tim Merchant Acquisition ingin menganalisis performa dari
merchant-merchant yang sudah ada selama ini dengan melihat beberapa
metrik, yaitu jumlah order yang telah diterima masing-masing merchant
serta total pendapatan (sebelum PPN) yang telah diterima oleh
masing-masing merchant selama ini. Tampilkan id_merchant, jumlah order
dan jumlah pendapatan sebelum PPN! Kemudian urutkan berdasarkan
jumlah pendapatan dari yang tertinggi.*/
SELECT 
	id_merchant, 
	COUNT(id_order) AS jumlah_order, 
	SUM(harga) AS jumlah_pendapatan_sebelum_ppn
FROM rakamin_order
GROUP BY id_merchant
ORDER BY jumlah_pendapatan_sebelum_ppn DESC;

/* Soal 4
Tim Payment ingin melakukan analisis terhadap metode
pembayaran yang paling populer selama ini. Tampilkan metode
pembayaran beserta frekuensi penggunaannya, namun hanya
tampilkan metode pembayaran yang memiliki frekuensi
penggunaan di atas 10 saja! Setelah itu urutkan berdasarkan
frekuensi dari yang terbanyak.*/
SELECT 
	metode_bayar, 
	COUNT(*) AS frekuensi_penggunaan
FROM rakamin_order
GROUP BY metode_bayar
HAVING COUNT(*) > 10
ORDER BY COUNT(*) DESC;

/* Soal 5
Tim Business Development ingin memikirkan strategi ekspansi ke
kota-kota lainnya. Sebelum itu, mereka ingin mengetahui ketimpangan
populasi pelanggan pada kota-kota yang ada sekarang. Mereka ingin
meminta informasi mengenai berapa jumlah terkecil pelanggan pada suatu
kota dan juga jumlah terbesar populasi pelanggan di kota yang paling
banyak pelanggannya. Tampilkan dua angka tersebut! (pada kota dengan
jumlah populasi pelanggan terkecil, berapa jumlahnya? dan juga untuk
kota dengan populasi pelanggan terbanyak, berapa jumlahnya?) */
SELECT 
    MIN(jumlah_pelanggan) AS jumlah_terkecil, 
    MAX(jumlah_pelanggan) AS jumlah_terbesar
FROM (
    SELECT 
		a.kota, 
		COUNT(*) AS jumlah_pelanggan
    FROM rakamin_customer AS c
    INNER JOIN 
		rakamin_customer_address AS a 
		ON c.id_pelanggan = a.id_pelanggan
    GROUP BY a.kota
) AS jumlah_pelanggan_per_kota;

/* Soal 6
Tim Payment ingin memperdalam analisis mereka mengenai
metode pembayaran. Kali ini mereka ingin melihat detail
penggunaan (frekuensi) masing-masing tipe pembayaran untuk
masing-masing merchant yang ada. Tampilkan nama merchant
(bukan hanya id_merchant), metode pembayaran dan frekuensi
pakainya! */
SELECT 
    rm.nama_merchant,
    ro.metode_bayar,
    COUNT(ro.metode_bayar) as frekuensi_pakai
FROM rakamin_order as ro 
	JOIN 
    	rakamin_merchant as rm 
    	ON ro.id_merchant = rm.id_merchant
GROUP BY 
    rm.nama_merchant,
    ro.metode_bayar
ORDER BY 
    rm.nama_merchant,
    frekuensi_pakai DESC;

/* Soal 7
Tim Marketing ingin memberikan reward kepada
pelanggan-pelanggan yang telah melakukan transaksi dengan
total kuantitas di atas 5. Untuk ini, tampilkan informasi
id_pelanggan, total kuantitas, nama dan email untuk pelanggan
yang memenuhi kriteria tersebut! (Lakukan dengan menggunakan
Common Table Expression). */
WITH TotalKuantitasPerPelanggan AS (
    SELECT
        o.id_pelanggan,
        SUM(o.kuantitas) AS total_kuantitas
    FROM rakamin_order AS o
    GROUP BY o.id_pelanggan
    HAVING SUM(o.kuantitas) > 5
)

SELECT
    c.id_pelanggan,
    c.nama,
    c.email,
    t.total_kuantitas
FROM rakamin_customer AS c
INNER JOIN TotalKuantitasPerPelanggan AS t
ON c.id_pelanggan = t.id_pelanggan;











