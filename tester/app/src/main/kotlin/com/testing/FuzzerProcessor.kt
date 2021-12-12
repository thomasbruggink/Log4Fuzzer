package com.testing

import com.fasterxml.jackson.databind.ObjectMapper
import com.fasterxml.jackson.module.kotlin.jacksonObjectMapper
import com.linecorp.armeria.client.WebClient
import com.linecorp.armeria.common.HttpMethod
import com.linecorp.armeria.common.HttpRequest
import com.linecorp.armeria.common.MediaType
import com.linecorp.decaton.processor.DecatonProcessor
import com.linecorp.decaton.processor.ProcessingContext
import mu.KLogging
import java.util.Base64

class FuzzerProcessor : DecatonProcessor<Event> {
    private val client: WebClient = WebClient.of()
    private val mapper: ObjectMapper = jacksonObjectMapper()
    private val decoder: Base64.Decoder = Base64.getDecoder()

    override fun process(context: ProcessingContext<Event>, task: Event) {
        try {
            if (task.PrettyHost == "localhost" || task.Host == "127.0.0.1") {
                return
            }
            val url = "${task.Scheme}://${task.PrettyHost}:${task.Port}${task.Path}"
            val builder = HttpRequest
                .builder()
                .method(HttpMethod.valueOf(task.Method))
                .path(url)

            if (task.Content != "") {
                builder.content(MediaType.OCTET_STREAM, decoder.decode(task.Content))
            }
            for (item in task.Headers) {
                builder.header(item.Key, item.Value)
            }
            val request = builder.build()
            val completable = context.deferCompletion()
            val mutation = task.Meta.getOrDefault("Mutation", "?")
            client.execute(request)
                .aggregate()
                .thenAccept {
                    logger.info { "${task.Method} ${task.PrettyHost} -> ${it.status()}, ${mutation}\n${request.headers()}\n${task.Content}" }
                    completable.complete()
                }
                .exceptionally {
                    // Probably fine
//                    logger.error(it) { "${task.Method} ${task.PrettyHost}" }
                    completable.complete()
                    throw it
                }
        } catch (ex: Throwable) {
//            logger.error(ex) { "error starting request: ${mapper.writeValueAsString(task)}" }
            // Probably fine
        }
    }

    private companion object : KLogging()
}
