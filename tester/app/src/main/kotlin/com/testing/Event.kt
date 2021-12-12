package com.testing

data class Header(
    val Key: String,
    val Value: String
)

data class Event(
    val Host: String,
    val PrettyHost: String,
    val Port: Int,
    val Method: String,
    val Scheme: String,
    val Authority: String,
    val Path: String,
    val HttpVersion: String,
    val Headers: List<Header>,
    val Content: String,
    val Trailers: List<Header>,
    val Timestamp: Double,
    val Meta: Map<String, String>
)
