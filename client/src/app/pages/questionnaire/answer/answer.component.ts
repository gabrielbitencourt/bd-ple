import { Component, OnInit } from '@angular/core';
import { FormControl, Validators, FormGroup } from '@angular/forms';
import { ActivatedRoute } from '@angular/router';
import { first } from 'rxjs/operators';
import { IHospital } from 'src/app/models/hospital';
import { IModules } from 'src/app/models/modules';
import { IParticipant } from 'src/app/models/participant';
import { FormRecordService } from 'src/app/services/form-record.service';
import { HospitalService } from 'src/app/services/hospital.service';
import { ModulesService } from 'src/app/services/modules.service';
import { ParticipantService } from 'src/app/services/participant.service';

@Component({
  selector: 'app-answer',
  templateUrl: './answer.component.html',
  styleUrls: ['./answer.component.scss']
})
export class AnswerComponent implements OnInit {

  hospitals: IHospital[] = [];
  participants: IParticipant[] = [];
  modules: IModules[] = [];

  participant = new FormControl('', [
    Validators.required
  ]);
  hospital = new FormControl('', [
    Validators.required
  ]);
  module = new FormControl('', [
    Validators.required
  ]);

  createForm = new FormGroup({
    participant: this.participant,
    hospital: this.hospital,
    module: this.module
  });

  constructor(
    private hospitalService: HospitalService,
    private participantService: ParticipantService,
    private modulesService: ModulesService,
    private formRecordService: FormRecordService,
    private route: ActivatedRoute) { }

  async ngOnInit(): Promise<void> {
    const paramMap = await this.route.paramMap.pipe(first()).toPromise();
    const questionnaireID = paramMap.get('questionnaireID');

    this.participants = await this.participantService.getAll().pipe(first()).toPromise();
    this.hospitals = await this.hospitalService.getAll().pipe(first()).toPromise();
    this.modules = await this.modulesService.getAll(questionnaireID).pipe(first()).toPromise();
  }

  createFormRecord() {
    this.formRecordService;
  }

}
