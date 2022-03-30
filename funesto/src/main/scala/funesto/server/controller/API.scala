package funesto.server.controller

import funesto.server.models.UserDTO
//import funesto.server.repository.UserRepository
import org.springframework.web.bind.annotation.{GetMapping, RequestMapping, RestController}
//import reactor.core.publisher.Flux

@RestController
@RequestMapping(Array("/funesto/api"))
class API(
           //           private val userRepository: UserRepository
         ) {
  @GetMapping(Array("/ping"))
  def ping: String = "pong"
  //  @GetMapping(Array("/users"))
  //  def users(): Flux[UserDTO] = {
  //    userRepository.findAll().map(_.toDTO)
  //  }
}
