package funesto.server.repository

import funesto.server.models.Book
import org.springframework.data.repository.reactive.ReactiveCrudRepository

trait BookRepository extends ReactiveCrudRepository[Book, Long] {}
