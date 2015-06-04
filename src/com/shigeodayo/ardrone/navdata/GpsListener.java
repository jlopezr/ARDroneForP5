package com.shigeodayo.ardrone.navdata;

public interface GpsListener {
	void GPSUpdated(double lat, double lon, double alt);
}
