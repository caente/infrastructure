package funesto.server.models

import org.springframework.data.annotation.Id
//import org.springframework.data.relational.core.mapping.Table

import scala.beans.BeanProperty

//@Table("users")
//case class User(
//                 @Id
//                 id: Long,
//                 name: String
//               ) {
//  def toDTO:UserDTO = UserDTO(id, name)
//}

case class UserDTO(@BeanProperty id: Long, @BeanProperty var name: String) {
  def this() = this(-1,"no name")
}