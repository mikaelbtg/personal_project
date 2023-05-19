-- Melakukan sort pada table berdasarkan kolom started_at dan menyimpan hasil query pada tabel trip_data
SELECT * 
INTO trip_data
FROM tripdata_jun_2022 
ORDER BY started_at ;

-- Menghapus 4 kolom titik koordinat pada tabel trip_data
ALTER TABLE trip_data 
	DROP COLUMN start_lat, 
	DROP COLUMN start_lng, 
	DROP COLUMN end_lat, 
	DROP COLUMN end_lng;

-- Memeriksa apakah ada duplikasi data yang terjadi pada tabel trip_data 
SELECT ride_id, count(ride_id)
FROM trip_data td 
GROUP BY ride_id 
HAVING count(ride_id) > 1

-- Memeriksa apakah ada data yang berada diluar cakupan waktu 
SELECT min(started_at), max(started_at) 
FROM trip_data td 

-- Memeriksa apakah ada nilai yang salah pada kolom rideable_type 
SELECT DISTINCT rideable_type 
FROM trip_data td 

-- Memeriksa apakah ada nilai yang salah pada kolom member_casual
SELECT DISTINCT member_casual 
FROM trip_data td 

-- Menghitung jumlah missing values pada masing-masing kolom
SELECT 
	sum(CASE WHEN ride_id IS NULL THEN 1 ELSE 0 END) AS ride_id,
	sum(CASE WHEN rideable_type IS NULL THEN 1 ELSE 0 END) AS rideable_type,
	sum(CASE WHEN started_at IS NULL THEN 1 ELSE 0 END) AS started_at,
	sum(CASE WHEN ended_at IS NULL THEN 1 ELSE 0 END) AS ended_at,
	sum(CASE WHEN start_station_name IS NULL THEN 1 ELSE 0 END) AS start_station_name ,
	sum(CASE WHEN start_station_id IS NULL THEN 1 ELSE 0 END) AS start_station_id ,
	sum(CASE WHEN end_station_name IS NULL THEN 1 ELSE 0 END) AS end_station_name ,
	sum(CASE WHEN end_station_id IS NULL THEN 1 ELSE 0 END) AS end_station_id ,
	sum(CASE WHEN member_casual IS NULL THEN 1 ELSE 0 END) AS member_casual
FROM trip_data td ;


/*Mengisi missing values pada 4 kolom dengan catatan 'unrecorded' yang menandakan tidak tercatatnya nilai pada kolom tersebut,
 * lalu bisa di cek lagi apakah sudah tidak ada missing values menggunakan query sebelumnya */ 
UPDATE trip_data 
SET 
	start_station_name = 'unrecorded', 
	start_station_id = 'unrecorded',
	end_station_name = 'unrecorded',
	end_station_id = 'unrecorded'
WHERE (start_station_name ISNULL AND start_station_id ISNULL) OR (end_station_name IS NULL AND end_station_id ISNULL); 


/* Menambahkan kolom lama penggunaan, hari waktu penggunaan, dan rute penggunaaan sepeda yang kemudian disimpan 
 * pada tabel trip_data_updated */
SELECT *,
	ended_at - started_at AS ride_length,
	EXTRACT("isodow" FROM started_at) AS day_of_week,
	concat(start_station_name, ' to ', end_station_name) AS track
INTO trip_data_updated
FROM trip_data td;

-- Menggunakan fitur ekspor pada aplikasi DBeaver untuk mengekspor tabel menjadi file csv
SELECT * FROM trip_data_updated tdu ;