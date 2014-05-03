package com.softwaremill.codebrag.stats

import akka.actor.Actor
import com.typesafe.scalalogging.slf4j.Logging
import com.softwaremill.codebrag.common.Clock

class StatsSenderActor(statsAggregator: StatsAggregator, httpSender: StatsHTTPRequestSender) extends Actor with Logging {

  def receive = {
    case StatsSenderActor.SendStatsCommand(clock: Clock) => {
      val stats = statsAggregator.getStatsForPreviousDayOf(clock.now)
      val json = stats.asJson
      logger.debug(s"Sending statistics: $json")
      sendStats(json)
    }
  }

  def sendStats(json: String) = httpSender.sendDailyStats(json)

}

object StatsSenderActor {
  case class SendStatsCommand(clock: Clock)
}