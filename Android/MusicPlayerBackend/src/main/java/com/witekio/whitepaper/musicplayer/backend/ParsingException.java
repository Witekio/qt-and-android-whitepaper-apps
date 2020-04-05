package com.witekio.whitepaper.musicplayer.backend;

class ParsingException extends Throwable {

    ParsingException(RuntimeException e) {
        super(e);
    }

}
