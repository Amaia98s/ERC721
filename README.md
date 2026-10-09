# Blockchain Accelerator NFT (BANFT)

Colección de NFTs basada en el estándar **ERC-721**, construida con [Foundry](https://getfoundry.sh) y [OpenZeppelin](https://openzeppelin.com/contracts). Las imágenes y los metadatos están alojados en **IPFS**.

## El contrato: `BANFTCollection.sol`

Hereda de `ERC721` de OpenZeppelin y añade:

| Elemento | Descripción |
|---|---|
| `mint()` | Cualquier usuario puede acuñar un NFT, sin coste, mientras queden disponibles. Revierte con `"Sold out"` al alcanzar el máximo. |
| `totalSupply` | Número máximo de NFTs de la colección (se fija en el despliegue). |
| `currentTokenId` | Contador del siguiente `tokenId` a acuñar. |
| `baseUri` | Ruta base de los metadatos (una carpeta de IPFS). |
| `tokenURI(id)` | Devuelve `baseUri + id + ".json"`, por ejemplo `ipfs://<CID>/0.json`. |
| `MintNFT` | Evento emitido en cada acuñación. |

Usa `_safeMint`, que comprueba que, si el receptor es un contrato, este sepa recibir NFTs.

## Metadatos

La carpeta `uris/` contiene el JSON de cada token en el formato estándar de metadatos que leen OpenSea y otros marketplaces:

```json
{
  "name": "Blockchain Accelerator NFT 0",
  "description": "NFT collection by Blockchain Accelerator - Jose Cruz",
  "image": "ipfs://bafybeiaqlrja5nohrji6qsj7x5vbncoh6ynoh3gyri74hi2ske7nkw676a",
  "attributes": [{ "trait_type": "Rarity", "value": 0 }]
}
```

Estos archivos se subieron a IPFS y el CID de la carpeta es el `baseUri` del contrato. Como el contenido de IPFS no se puede modificar, la copia publicada todavía tiene la clave antigua `trait_tipe`; para corregirla hay que volver a subir la carpeta `uris/` y desplegar con el nuevo CID.

## Despliegue

El script `script/DeployNFTCollection.s.sol` despliega la colección con:

- Nombre: `Blockchain Accelerator NFT`
- Símbolo: `BANFT`
- Suministro máximo: `2`
- Base URI: `ipfs://bafybeidorqazjivjlnpvxi7ofqf4qid6qmmochqspmcpl7gwg25eore4ya/`

Lee la clave privada de la variable de entorno `PRIVATE_KEY`. Créala en un archivo `.env` (ya está en el `.gitignore`, **nunca lo subas**):

```bash
PRIVATE_KEY=0x...
```

Y ejecuta:

```bash
source .env
forge script script/DeployNFTCollection.s.sol --rpc-url <URL_RPC> --broadcast
```

## Tests

`test/BANFTCollection.t.sol` incluye 7 tests que verifican:

- Despliegue con el nombre, el símbolo, el suministro máximo y la base URI correctos.
- Acuñación del NFT y asignación al usuario que lo acuña.
- Ids consecutivos (0, 1, ...) en acuñaciones sucesivas.
- Evento `MintNFT` emitido con el id recién acuñado.
- Rechazo con `"Sold out"` al superar el suministro máximo.
- `tokenURI` correcto, y error al pedirlo para un token que no existe.

## Uso

Requiere [Foundry](https://book.getfoundry.sh/getting-started/installation).

```bash
git clone --recursive https://github.com/Amaia98s/ERC721.git
cd ERC721
forge build
forge test -vvv
```

## Tecnologías

Solidity 0.8.33 · Foundry · OpenZeppelin Contracts (ERC721, Strings) · IPFS
