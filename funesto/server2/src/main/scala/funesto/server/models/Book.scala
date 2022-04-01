package funesto.server.models

import org.springframework.data.annotation.Id
import org.springframework.data.relational.core.mapping.Table

import scala.beans.BeanProperty

@Table( "books" )
case class Book(
    @Id
    id: Long,
    name: String) {
  def toDTO: BookDTO = BookDTO( id, name )
}

case class BookDTO(@BeanProperty id: Long, @BeanProperty var name: String ) {
  def this() = this( -1, "no name" )
}
