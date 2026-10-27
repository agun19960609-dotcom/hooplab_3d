package com.example.hooplab_3d

import android.graphics.BitmapFactory
import android.graphics.Color
import android.graphics.Rect
import android.media.MediaCodec
import android.media.MediaCodecInfo
import android.media.MediaFormat
import android.media.MediaMuxer
import java.io.File

object ReelEncoder {
    fun encode(dir: String, fps: Int, width: Int, height: Int, output: String): Boolean {
        val frames = File(dir).listFiles { file ->
            file.isFile && file.name.endsWith(".jpg")
        }?.sortedBy { it.name } ?: return false
        if (frames.isEmpty()) return false

        val format = MediaFormat.createVideoFormat(MediaFormat.MIMETYPE_VIDEO_AVC, width, height)
        format.setInteger(
            MediaFormat.KEY_COLOR_FORMAT,
            MediaCodecInfo.CodecCapabilities.COLOR_FormatSurface,
        )
        format.setInteger(MediaFormat.KEY_BIT_RATE, 2_000_000)
        format.setInteger(MediaFormat.KEY_FRAME_RATE, fps.coerceAtLeast(1))
        format.setInteger(MediaFormat.KEY_I_FRAME_INTERVAL, 1)

        val codec = MediaCodec.createEncoderByType(MediaFormat.MIMETYPE_VIDEO_AVC)
        codec.configure(format, null, null, MediaCodec.CONFIGURE_FLAG_ENCODE)
        val surface = codec.createInputSurface()
        codec.start()

        val muxer = MediaMuxer(output, MediaMuxer.OutputFormat.MUXER_OUTPUT_MPEG_4)
        var track = -1
        var muxing = false
        var written = 0
        val info = MediaCodec.BufferInfo()

        fun drain(endOfStream: Boolean) {
            if (endOfStream) codec.signalEndOfInputStream()
            var spins = 0
            while (spins < 240) {
                val index = codec.dequeueOutputBuffer(info, 10_000)
                when {
                    index == MediaCodec.INFO_TRY_AGAIN_LATER -> {
                        if (!endOfStream) return
                        spins += 1
                    }
                    index == MediaCodec.INFO_OUTPUT_FORMAT_CHANGED -> {
                        if (muxing) error("Format changed twice")
                        track = muxer.addTrack(codec.outputFormat)
                        muxer.start()
                        muxing = true
                        spins = 0
                    }
                    index >= 0 -> {
                        val buffer = codec.getOutputBuffer(index)
                        val config = info.flags and MediaCodec.BUFFER_FLAG_CODEC_CONFIG != 0
                        if (buffer != null && info.size > 0 && !config && muxing) {
                            buffer.position(info.offset)
                            buffer.limit(info.offset + info.size)
                            info.presentationTimeUs = written * 1_000_000L / fps.coerceAtLeast(1)
                            muxer.writeSampleData(track, buffer, info)
                            written += 1
                        }
                        codec.releaseOutputBuffer(index, false)
                        spins = 0
                        if (info.flags and MediaCodec.BUFFER_FLAG_END_OF_STREAM != 0) return
                    }
                    else -> if (!endOfStream) return else spins += 1
                }
            }
        }

        try {
            for (frame in frames) {
                val bitmap = BitmapFactory.decodeFile(frame.absolutePath) ?: continue
                val canvas = surface.lockCanvas(null)
                canvas.drawColor(Color.BLACK)
                canvas.drawBitmap(bitmap, null, Rect(0, 0, width, height), null)
                surface.unlockCanvasAndPost(canvas)
                bitmap.recycle()
                drain(false)
            }
            drain(true)
            if (muxing) muxer.stop()
            return written > 0 && File(output).length() > 32
        } finally {
            muxer.release()
            codec.stop()
            codec.release()
        }
    }
}
