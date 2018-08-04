module Kafka.Admin
where

import Control.Monad.IO.Class
import qualified Data.Map as Map
import Kafka.Internal.RdKafka
import Kafka.Internal.Setup
import Kafka.Types

data AdminClient = AdminClient
  { acKafkaPtr  :: !RdKafkaTPtr
  , acKafkaConf :: !KafkaConf
  , acOptions   :: !RdKafkaAdminOptionsTPtr
  }

newAdminClient :: MonadIO m => m (Either KafkaError AdminClient)
newAdminClient = liftIO $ do
  kc@(KafkaConf kc' _ _) <- kafkaConf (KafkaProps Map.empty)
  mbKafka <- newRdKafkaT RdKafkaProducer kc'
  case mbKafka of
    Left err    -> return . Left $ KafkaError err
    Right kafka -> do
      opts <- newRdKafkaAdminOptions kafka RdKafkaAdminOpAny
      return $ Right $ AdminClient kafka kc opts

