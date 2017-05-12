# PSE Móvil inside

PSE Móvil permite a los clientes que utilizan dispositivos móviles autorizar pagos desde una APP en vez de usar el navegador Web. Esto permite mayor control, recordar credenciales de forma segura y una experiencia nativa.

PSE Móvil puede ser embebido directamente en las aplicaciones de los comercios y con esto mejorar notablemente la experiencia del usuario al mantener todo el proceso de compra dentro de la APP del comerico.

Este repositorio es ejemplo y documentación del proceso para integrar la tecnología Browser2App (usada en PSE Móvil) en la APP del comercio.


# Manual de uso la biblioteca nativa Browser2app en iOS (com.browser2app:khenshin:*) 

Esta aplicación ha sido creada para demostrar la utilización de nuestra biblioteca khenshin.
Para poder ejecutar esta aplicación es necesario que tengas acceso a nuestro repositorio privado: https://dev.khipu.com/nexus/content/repositories/browser2app

Los pasos necesarios para utilizar la biblioteca nativa iOS para Browser2app son:

1. [Agregar Khenshin Pod](#cocoapod)
2. [Configuración de Khenshin](#configuración-de-khenshin)
3. [Ejemplo configuración de Khenshin](#ejemplo-de-configuración)
4. [Invocar browser2app desde tu app](#invocación)
6. [Recibir la respuesta en tu app](#respuesta)


## Cocoapod
Para instalar khenshin en tu proyecto es necesario utilizar [cocoapods](https://guides.cocoapods.org/using/getting-started.html).
> **Archivo Podfile**  
> pod 'khenshin', :git => 'https://bitbucket.org/khipu/khenshin-pod.git', :tag => '1.50'

*Importante*: Cocoapods debe estar configurado con la opción **use_frameworks!**
    
## Configuración de Khenshin

Antes de utilizar la biblioteca para realizar pagos, debes realizar la configuración

* **NavigationBarCenteredLogo**: imagen para ubicarla al centro de la barra de navegación durante la inicialización.  
* **NavigationBarLeftSideLogo**: imagen para ubicarla a la izquierda de la barra de navegación en caso que se habilite **"Mira Como Funciona"**.  
* **AutomatonAPIURL**: dirección URL para descargar los autómatas(*).
* **CerebroAPIURL**: dirección URL para informar de progreso de pago(*).
* **processHeader**: Si has diseñado tu propio encabezado para el proceso de pago, éste es el parámetro para entregar una vista que implemente el protocolo *ProcessHeader*.
* **processFailure**: Si has diseñado tu propia vista de fallo, éste es el parámetro para entregar un controlador que implemente el protocolo *ProcessExit*.
* **processSuccess**: Si has diseñado tu propia vista de éxito, éste es el parámetro para entregar un controlador que implemente el protocolo *ProcessExit*.
* **processWarning**: Si has diseñado tu propia vista de advertencia, éste es el parámetro para entregar un controlador que implemente el protocolo *ProcessExit*.
* **allowCredentialsSaving**: permites guardar credenciales. Por omisión es falso.
* **mainButtonStyle**: tipo de botón "Continuar". Las opciones se encuentran en "KhenshinEnums.h". Por omisión el botón va en la barra de navegación.
* **hideWebAddressInformationInForm**: permite esconder el UITextField que muestra información de la dirección web en que se encuentra el usuario. Por omisión se muestra esta información.
* **useBarCenteredLogoInForm**: En caso que se esconda la información de dirección puedes utilizar el logo *NavigationBarCenteredLogo* como relleno.
* **principalColor**: Para pintar la barra de navegación y el botón principal.
* **darkerPrincipalColor**: Para pintar el color secundario del botón principal.
* **secondaryColor**: asigna el TintColor de UIButton.
* **navigationBarTextTint**: asigna el TintColor de UINavigationBar.
* **font**: Si deseas asignar una fuente a khenshin.

**En esta versión, si no quieres utilizar imágenes puedes asignar una imagen vacía**

> [[UIImage alloc] init]

(*) Éstos datos serán entregados por tu *ejecutivo* ***Browser2app***
	
## Ejemplo de Configuración
**Detalle se encuentra en AppDelegate.m**

    [KhenshinInterface initWithNavigationBarCenteredLogo:[UIImage imageNamed:@"Bar Logo"]
                               NavigationBarLeftSideLogo:[[UIImage alloc] init]
                                         automatonAPIURL:automatonAPIURL
                                           cerebroAPIURL:cerebroAPIURL
                                           processHeader:(UIView<ProcessHeader>*)[self processHeader]
                                          processFailure:(UIViewController<ProcessExit>*)[self failureViewController]
                                          processSuccess:(UIViewController<ProcessExit>*)[self successViewController]
                                          processWarning:(UIViewController<ProcessExit>*)[self warningViewController]
                                  allowCredentialsSaving:NO
                                         mainButtonStyle:KHMainButtonFatOnForm
                         hideWebAddressInformationInForm:NO
                                useBarCenteredLogoInForm:NO
                                          principalColor:[self principalColor]
                                    darkerPrincipalColor:[self darkerPrincipalColor]
                                          secondaryColor:[self secondaryColor]
                                   navigationBarTextTint:[self navigationBarTextTint]
                                                    font:nil];
    
    [KhenshinInterface setPreferredStatusBarStyle:UIStatusBarStyleLightContent]; 
    
## Invocación

Antes de invocar la biblioteca es necesario utilizar la API de ACH Colombia para generar un pago de manera estandar hasta el punto en que se obtiene la URL de redirección hacia el registro PSE que es de la forma

	https://registro.pse.com.co/PSEUserRegister/StartTransaction.htm?enc=XXXXXXXXXX


Al valor del parámetro "enc" de la url anterior le llamaremos ecus o cus encodeado.
 
Adicionalmente a eso se debe saber el identificador de la entidad financiera autorizadora y el tipo de cliente que ha sido seleccionado según los mismos códigos usados al momento de consultarle al usuario su banco, es decir:

Entidades financieras autorizadoras:

```
- 1040: BANCO AGRARIO
- 1052: BANCO AV VILLAS
- 1013: BANCO BBVA COLOMBIA S.A.
- 1032: BANCO CAJA SOCIAL
- 1019: BANCO COLPATRIA
- 1066: BANCO COOPERATIVO COOPCENTRAL
- 1006: BANCO CORPBANCA S.A
- 1051: BANCO DAVIVIENDA
- 1001: BANCO DE BOGOTA
- 1023: BANCO DE OCCIDENTE
- 1062: BANCO FALABELLA 
- 1012: BANCO GNB SUDAMERIS
- 1060: BANCO PICHINCHA S.A.
- 1002: BANCO POPULAR
- 1058: BANCO PROCREDIT
- 1007: BANCOLOMBIA
- 1061: BANCOOMEVA S.A.
- 1009: CITIBANK 
- 1014: HELM BANK S.A.
- 1507: NEQUI
```
Tipos de usuario:

```
- 0: Persona natural
- 1: Persona jurídica
```

Con estos datos se puede realizar la invocación:

```
    [KhenshinInterface startEngineWithAutomatonId:[NSString stringWithFormat:@"%@%@", userTypeId, authorizerId]
                                         animated:YES
                                       parameters:@{@"cus": [[self formValues] valueForKey:@"cus"],
                                                    @"amount": [[self formValues] valueForKey:@"amount"],
                                                    @"authorizerId": authorizerId,
                                                    @"subject": [[self formValues] valueForKey:@"subject"],
                                                    @"merchant": [[self formValues] valueForKey:@"merchant"],
                                                    @"cancelURL": [[self formValues] valueForKey:@"returnURL"],
                                                    @"paymentId": [[self formValues] valueForKey:@"cus"],
                                                    @"userType": userTypeId,
                                                    @"returnURL": [[self formValues] valueForKey:@"returnURL"],
                                                    @"payerEmail": [[self formValues] valueForKey:@"payerEmail"]}
                                   userIdentifier:nil
                                          success:^(NSURL *returnURL) {
                                              
                                              NSLog(@"Volver con ¡éxito!");
                                          } failure:^(NSURL *returnURL) {
                                              
                                              NSLog(@"Volver con fracaso :(");
                                          }];
```

Todos los campos deben coincidir exáctamente con los utilizados al momento de crear el pago usando los webservices de ACH si algún campo no coincide la aplicación le mostrará un mensaje de error del tipo "Datos inconsistentes".

Lo mismo ocurre con el campo "merchant" que debe coincidir exáctamente con el nombre del comercio registrado en ACH Colombia, por ejemplo si el nombre del comercio es "ACH Colombia S.A." e intentamos iniciar un pago entregando en el parámetro "merchant" la cadena "ACH Colombia" el pago fallará con error de "Datos inconsistentes".

## Respuesta

Al iniciar khenshin defines qué hacer en caso de Éxito o Fracaso utilizandos los bloques:  

* **Success**: proceso a ejecutar cuando termina exitosamente el proceso de pago.  
* **Failure**: proceso a ejecutar cuando termina con fallas el proceso de pago.

    