package funesto.server.controller

import funesto.server.models.BookDTO
import funesto.server.repository.BookRepository
import org.springframework.web.bind.annotation.{ GetMapping, RequestMapping, RestController }
import reactor.core.publisher.Flux

@RestController
@RequestMapping( Array( "/server2/api" ) )
class API(private val bookRepository: BookRepository ) {
  @GetMapping( Array( "/ping" ) )
  def ping: String = "pong"

  @GetMapping( Array( "/books" ) )
  def users(): Flux[BookDTO] = {
    bookRepository.findAll().map( _.toDTO )
  }
}
