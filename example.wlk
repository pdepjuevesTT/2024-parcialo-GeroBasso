class Persona {
  var property sueldo
  var property cosas = []
  var property plata
  var property formasDePago = []
  var property formaPreferida 
  var property cuotas = []
  var property sueldoActual = 0

  method cambiarFormaPreferida(forma){
    if (formasDePago.contains(forma)) formaPreferida = forma
  }

  method cobrarSueldo(){
    sueldoActual = sueldo
    self.pagarCuotas()
    plata += sueldoActual
  }

  method aumentoSueldo(monto){
    sueldo += monto
  }

  method pagar(monto) {
    formaPreferida.pagar(monto)

  }

  method pagarCuotas(){
    cuotas.forEach([{cuota => cuota.pagar(sueldoActual)}])

  }

  method actualizarMonto(numero){
    sueldoActual -= numero
  }

  method agregarCuotas(cant, monto){
    const nuevaCuota = new Cuotas(titular = self)
    nuevaCuota.armar(cant, monto)
    cuotas.add(nuevaCuota)
  }

  method comprar(cosa){
    if (formaPreferida.alcanza(cosa.precio())) {
      self.pagar(cosa.precio())
      cosas.add(cosa)
    }
  }

  method calcularCuotasVencidas() = cuotas.map({cuota=> cuota.calcularCuotasVencidas()}).sum()
  
  method cuantasCosasTiene() = cosas.size()

}

object personasTotales {
  var mesActual = 1
  var property personas = []
  method terminarMes() {
    personas.forEach({persona => persona.cobrarSueldo()})
    self.pasarMes()
  }

  method pasarMes(){
    if (mesActual == 12) mesActual = 1
    else mesActual += 1
  }

  method personaQueMasTiene() = personas.max({persona=>persona.cuantasCosasTiene()})

}

class Efectivo {
  var property titular
  method pagar(monto){
    titular.actualizarMonto(monto)
  }

  method alcanza(precio) = titular.plata() >= precio

}

class CuentaBancaria {
  var property saldo
    method pagar(precio){
      saldo-= precio

  }

  method alcanza(precio) = saldo >= precio

}

class TarjetaCredito {
  var property cuotas
  var property tasaInteres
  var property maximo
  var property titular

    method pagar(monto){
      titular.agregarCuota(cuotas, self.calcularValorCuota(monto))

  }

  method alcanza(precio) = maximo >= precio

  method calcularValorCuota(monto) = (monto * (tasaInteres/100)) / cuotas

}

//invento con Herencia
class TarjetaCreditoX inherits TarjetaCredito {
  override method calcularValorCuota(monto) = if (titular.calcularCuotasVencidas()>0) super(monto) else super(monto)/2
}

class Cuotas {
  var property cuota = []
  const titular 

  method pagar(plata){
    if(self.alcanza(plata)) {
      cuota.remove(cuota.get(0))
      titular.actualizarMonto(cuota.get(0).monto())

    } else 

    cuota.get(0).cambiarEstado()



  } 

  method calcularCuotasVencidas() = cuota.filter({cuota => cuota.estaVencida()}).map({cuota=>cuota.mostrarMonto()}).sum()

  method armar(cant, monto){
    cant.times({cuota.add(new Cuota(monto = monto))})
  }

  method alcanza(plata) = plata >= cuota.get(0).monto()
}

class Cuota{
  const property monto 
  var property estado = "noVencida" 

  method mostrarMonto() = monto

  method cambiarEstado(){
    estado = "vencida"
  } 

  method estaVencida() = estado == "vencida"
}


class Cosa {
  var property precio
}

// segunda parte

class CompradorCompulsivo inherits Persona{
    override method comprar(cosa){
      if (formaPreferida.alcanza(cosa.precio())) {
      self.pagar(cosa.precio())
      cosas.add(cosa)
    } else self.encontrarOtraForma(cosa)

      
    }

    method encontrarOtraForma(cosa){
      if(formasDePago.any({forma =>formaPreferida.alcanza(cosa.precio()) })){
      formaPreferida = formasDePago.any({forma =>formaPreferida.alcanza(cosa.precio()) })
      self.comprar(cosa)
    }
    }
}

class PagadorCompulsivo inherits Persona{

  override method cobrarSueldo(){
    super()
    if(self.calcularCuotasVencidas()>0){
      sueldoActual += plata
      super()
    }
  }
  
}




